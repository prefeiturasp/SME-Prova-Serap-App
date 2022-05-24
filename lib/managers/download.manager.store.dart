import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/arquivo_video.response.dto.dart';
import 'package:appserap/dtos/contexto_prova.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes.response.dto.dart';
import 'package:appserap/dtos/questao_completa.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/exceptions/prova_download.exception.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/utils/notificacao.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/universal/universal.util.dart';
import 'package:chopper/chopper.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:supercharged_dart/supercharged_dart.dart';
part 'download.manager.store.g.dart';

typedef StatusChangeCallback = void Function(
    EnumDownloadStatus downloadStatus, double porcentagem, double tempoPrevisto);
typedef TempoPrevistoChangeCallback = void Function(double tempoPrevisto);

class DownloadManagerStore = _DownloadManagerStoreBase with _$DownloadManagerStore;

abstract class _DownloadManagerStoreBase with Store, Loggable {
  ProvaStore? provaStore;
  late int provaId;

  AppDatabase db = ServiceLocator.get();
  ApiService apiService = ServiceLocator.get();

  // late List<DownloadProvaDb> downloads;

  late DateTime inicio;
  late int downloadAtual;
  bool _isPauseAllDownloads = false;

  StatusChangeCallback? onStatusChangeCallback;

  Timer? timer;
  TempoPrevistoChangeCallback? onTempoPrevistoChangeCallback;

  _DownloadManagerStoreBase({ProvaStore? provaStore, int? provaId}) {
    if (provaStore != null) {
      this.provaStore = provaStore;
      this.provaId = provaStore.id;
    } else {
      this.provaId = provaId!;
    }
  }

  iniciarDownload() async {
    info('DownloadManagerStore.iniciarDownload');

    _isPauseAllDownloads = false;

    try {
      await retry(
        () async {
          await _carregarProva();
          await _salvarProva();
          await _validarProva();
        },
        maxAttempts: 5,
        onRetry: (e) {
          fine('[Prova $provaId] - Tentativa de download da prova');
          severe(e);
        },
      );
    } on ProvaDownloadException catch (e) {
      NotificacaoUtil.showSnackbarError(e.toString());
      await _updateProvaDownloadStatus(provaId, EnumDownloadStatus.ERRO);
    } on Exception catch (e, stacktrace) {
      NotificacaoUtil.showSnackbarError(
          "Não foi possível baixar a prova ${provaStore?.prova.descricao ?? 'id: $provaId'}");
      await _updateProvaDownloadStatus(provaId, EnumDownloadStatus.NAO_INICIADO);
      severe(e);
      severe(stacktrace);
    }
  }

  listen(StatusChangeCallback callback) {
    onStatusChangeCallback = callback;
  }

  pauseAllDownloads() {
    _isPauseAllDownloads = true;
  }

  _carregarProva() async {
    salvarBanco(DownloadProvaDb download) async {
      await db.downloadProvaDao.inserirOuAtualizar(download);
    }

    // carregar do banco
    var downloads = await db.downloadProvaDao.getByProva(provaId);

    info(' [Prova $provaId] - Carregando informações da prova');
    // carregar da url
    var response = await ServiceLocator.get<ApiService>().prova.getResumoProva(idProva: provaId);

    if (!response.isSuccessful) {
      return;
    }

    ProvaDetalhesResponseDTO provaDetalhes = response.body!;

    // adcionar o que nao tem no banco
    info(" [Prova $provaId] - Adicionando downloads da prova - Questão");
    for (var idQuestao in provaDetalhes.questoesIds) {
      if (!_containsId(downloads, idQuestao, EnumDownloadTipo.QUESTAO)) {
        await salvarBanco(
          DownloadProvaDb(
            id: idQuestao,
            provaId: provaId,
            tipo: EnumDownloadTipo.QUESTAO,
            downloadStatus: EnumDownloadStatus.NAO_INICIADO,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    info(" [Prova $provaId] - Adicionando downloads da prova - Contexto da prova");
    for (var idContexto in provaDetalhes.contextosProvaIds) {
      if (!_containsId(downloads, idContexto, EnumDownloadTipo.CONTEXTO_PROVA)) {
        await salvarBanco(
          DownloadProvaDb(
            id: idContexto,
            provaId: provaId,
            tipo: EnumDownloadTipo.CONTEXTO_PROVA,
            downloadStatus: EnumDownloadStatus.NAO_INICIADO,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    downloads = await db.downloadProvaDao.getByProva(provaId);

    info('''[Prova $provaId] - Carregando informações da prova - Finalizado

      ${(await getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO, downloads)).length} concluídos
      ${(await getDownlodsByStatus(EnumDownloadStatus.PAUSADO, downloads)).length} pausados
      ${(await getDownlodsByStatus(EnumDownloadStatus.NAO_INICIADO, downloads)).length} não iniciados
      ${(await getDownlodsByStatus(EnumDownloadStatus.ERRO, downloads)).length} erros
      ''');
  }

  bool _containsId(List<DownloadProvaDb> downloads, int id, EnumDownloadTipo tipo) {
    return downloads.firstWhereOrNull((element) => element.id == id && element.tipo == tipo) != null;
  }

  _salvarProva() async {
    var downloads = await db.downloadProvaDao.getByProva(provaId);

    var downloadsNaoConcluidos =
        downloads.filter((element) => element.downloadStatus != EnumDownloadStatus.CONCLUIDO).toList();

    downloadAtual = downloads.length - (await getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO, downloads)).length;
    inicio = DateTime.now();

    downloads.sort((a, b) => a.tipo.order.compareTo(b.tipo.order));

    info(" [Prova $provaId] - Iniciando download da prova - ${downloadsNaoConcluidos.length} não concluidos");

    startTimer();

    for (int i = 1; i <= downloadsNaoConcluidos.length; i++) {
      var download = downloadsNaoConcluidos[i - 1];
      finer('[Prova $provaId] - Iniciando download  ${download.id} - ${download.tipo}');

      try {
        if (_isPauseAllDownloads) {
          info("[Prova $provaId] - Pausando todos os downloads");
          await _pause();
          break;
        }

        await atualizarStatus(downloads, EnumDownloadStatus.BAIXANDO);

        switch (download.tipo) {
          case EnumDownloadTipo.QUESTAO:
            await retry(
              () async => await baixarQuestao(download),
              maxAttempts: 3,
              onRetry: (e) {
                fine('[Prova $provaId] - Tentativa de download da Questão ID: ${download.id}');
                severe(e);
              },
            );

            break;

          case EnumDownloadTipo.CONTEXTO_PROVA:
            await retry(
              () async => await baixarContextoProva(download),
              maxAttempts: 3,
              onRetry: (e) {
                fine('[Prova $provaId] - Tentativa de download do Contexto ID: ${download.id}');
                severe(e);
              },
            );
            break;

          default:
            break;
        }

        downloadAtual = i;
      } on Exception catch (e, stack) {
        severe('[Prova $provaId] - ERRO: $e');
        severe(download);
        severe(stack);

        await _updateDownloadStatus(download, EnumDownloadStatus.ERRO);
      }
    }
  }

  Future<int> informarDownloadConcluido(int idProva) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String modeloDispositivo = "";
    String dispositivoId = "";
    String versao = "";

    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      modeloDispositivo = webBrowserInfo.userAgent!;
      versao = webBrowserInfo.appVersion!;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      modeloDispositivo = "${androidInfo.manufacturer!} ${androidInfo.model!}";
      dispositivoId = androidInfo.androidId!;
      versao = "Android ${androidInfo.version.release} (SDK ${androidInfo.version.release})";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      modeloDispositivo = "Apple ${iosInfo.model!}";
      dispositivoId = iosInfo.identifierForVendor!;
      versao = "${iosInfo.systemName} ${iosInfo.systemVersion}";
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      modeloDispositivo = "Microsoft ${windowsInfo.computerName}";
      dispositivoId = "${windowsInfo.numberOfCores} cores ${windowsInfo.systemMemoryInMegabytes} MB";
      versao = "Windows";
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      modeloDispositivo = "Apple ${macOsInfo.arch} ${macOsInfo.model} ${macOsInfo.memorySize}MB";
      dispositivoId = "${macOsInfo.systemGUID} ${macOsInfo.computerName} ${macOsInfo.hostName}";
      versao = "MacOS ${macOsInfo.osRelease}";
    }

    var response = await ServiceLocator.get<ApiService>().download.informarDownloadConcluido(
          provaId: idProva,
          tipoDispositivo: kDeviceType.index,
          dispositivoId: dispositivoId,
          modeloDispositivo: modeloDispositivo,
          versao: versao,
          dataHora: DateTime.now().toIso8601String(),
        );

    if (response.isSuccessful) {
      return response.body!;
    }

    return -1;
  }

  Future<void> _pause() async {
    try {
      var downloads = await db.downloadProvaDao.getByProva(provaId);

      int downloadsPendentes = 0;

      for (var download in downloads) {
        if (download.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
          await _updateDownloadStatus(download, EnumDownloadStatus.PAUSADO);
          downloadsPendentes++;
        }
      }

      await _updateProvaDownloadStatus(provaId, EnumDownloadStatus.PAUSADO);

      info("[Prova $provaId] - Download pausado - $downloadsPendentes pendentes");
    } finally {
      _isPauseAllDownloads = false;
    }
  }

  onTempoPrevistoChange(void Function(double tempoPrevisto) onTempoPrevistoChangeCallback) {
    this.onTempoPrevistoChangeCallback = onTempoPrevistoChangeCallback;
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (onTempoPrevistoChangeCallback != null) {
        var downloads = await db.downloadProvaDao.getByProva(provaId);
        onTempoPrevistoChangeCallback!(getTempoPrevisto(downloads));
      }
    });
  }

  cancelTimer() {
    timer?.cancel();
  }

  Future<double> getPorcentagem(List<DownloadProvaDb> downloads) async {
    var downloadsDb = await db.downloadProvaDao.getByProva(provaId);
    int baixado = downloadsDb.where((element) => element.downloadStatus == EnumDownloadStatus.CONCLUIDO).length;

    return baixado / downloads.length;
  }

  double getTempoPrevisto(List<DownloadProvaDb> downloads) {
    return (downloads.length - downloadAtual) / (downloadAtual / (DateTime.now().difference(inicio).inSeconds));
  }

  Future<List<DownloadProvaDb>> getDownlodsByStatus(EnumDownloadStatus status,
      [List<DownloadProvaDb>? downloads]) async {
    downloads ??= await db.downloadProvaDao.getByProva(provaId);
    return downloads.where((element) => element.downloadStatus == status).toList();
  }

  baixarQuestao(DownloadProvaDb download) async {
    await _updateDownloadStatus(download, EnumDownloadStatus.BAIXANDO);

    Response<List<QuestaoCompletaResponseDTO>> response =
        await apiService.questao.getQuestaoCompleta(ids: [download.id]);

    if (response.isSuccessful) {
      QuestaoCompletaResponseDTO questaoDTO = response.body![0];

      var questao = QuestaoDb(
        id: questaoDTO.id,
        titulo: questaoDTO.titulo,
        descricao: questaoDTO.descricao,
        ordem: questaoDTO.ordem,
        tipo: questaoDTO.tipo,
        provaId: provaId,
        quantidadeAlternativas: questaoDTO.quantidadeAlternativas,
      );

      await db.questaoDao.inserirOuAtualizar(questao);

      await baixarAlternativa(questaoDTO.alternativas);
      await baixarArquivoImagem(questaoDTO.arquivos);
      await baixarArquivoVideo(questaoDTO.videos);
      await baixarArquivoAudio(questaoDTO.audios);

      await _updateDownloadStatus(download, EnumDownloadStatus.CONCLUIDO);
    } else {
      await _updateDownloadStatus(download, EnumDownloadStatus.ERRO);
    }
  }

  baixarAlternativa(List<AlternativaResponseDTO> alternativas) async {
    for (var alternativaDTO in alternativas) {
      AlternativaDb alternativaDb = AlternativaDb(
        id: alternativaDTO.id,
        provaId: provaId,
        descricao: alternativaDTO.descricao,
        ordem: alternativaDTO.ordem,
        numeracao: alternativaDTO.numeracao,
        questaoId: alternativaDTO.questaoId,
      );

      await db.alternativaDao.inserirOuAtualizar(alternativaDb);
    }
  }

  baixarContextoProva(DownloadProvaDb download) async {
    await _updateDownloadStatus(download, EnumDownloadStatus.BAIXANDO);

    Response<ContextoProvaResponseDTO> response = await apiService.contextoProva.getContextoProva(id: download.id);

    if (response.isSuccessful) {
      ContextoProvaResponseDTO contexto = response.body!;

      http.Response contextoResponse = await http.get(
        Uri.parse(
          contexto.imagem!.replaceFirst('http://', 'https://'),
        ),
      );

      String base64 = base64Encode(contextoResponse.bodyBytes);

      var contextoProva = ContextoProvaDb(
        id: contexto.id,
        imagem: contexto.imagem,
        imagemBase64: base64,
        ordem: contexto.ordem,
        posicionamento: contexto.posicionamento,
        provaId: contexto.provaId,
        texto: contexto.texto,
        titulo: contexto.titulo,
      );

      await db.contextoProvaDao.inserirOuAtualizar(contextoProva);

      await _updateDownloadStatus(download, EnumDownloadStatus.CONCLUIDO);
    }
  }

  baixarArquivoImagem(List<ArquivoResponseDTO> arquivos) async {
    for (var arquivoDTO in arquivos) {
      try {
        ArquivoDb? arquivoDb = await db.arquivoDao.findByLegadoId(arquivoDTO.legadoId);

        if (arquivoDb == null) {
          http.Response arquivoResponse = await http.get(
            Uri.parse(
              arquivoDTO.caminho.replaceFirst('http://', 'https://'),
            ),
          );

          if (arquivoResponse.statusCode == 200) {
            String base64 = base64Encode(arquivoResponse.bodyBytes);

            var arquivo = ArquivoDb(
              id: int.parse("${arquivoDTO.id}${arquivoDTO.questaoId}"),
              provaId: provaId,
              legadoId: arquivoDTO.legadoId,
              caminho: arquivoDTO.caminho,
              base64: base64,
              questaoId: arquivoDTO.questaoId,
            );

            await db.arquivoDao.inserirOuAtualizar(arquivo);
          } else {
            severe("[Prova $provaId] - Erro ao baixar arquivo ${arquivoDTO.id} - Status ${arquivoResponse.statusCode}");
          }
        }
      } catch (e) {
        severe("[Prova $provaId] - Erro ao baixar arquivo de imagem ${arquivoDTO.id} - ${e.toString()}");
        rethrow;
      }
    }
  }

  baixarArquivoVideo(List<ArquivoVideoResponseDTO> videos) async {
    for (var arquivoVideoDTO in videos) {
      try {
        var arquivoVideoDb = await db.arquivosVideosDao.findById(arquivoVideoDTO.id);

        if (arquivoVideoDb == null) {
          String path = join(
            'prova',
            provaId.toString(),
            'video',
            arquivoVideoDTO.questaoId.toString() + extension(arquivoVideoDTO.caminho),
          );

          await salvarArquivoLocal(arquivoVideoDTO.caminho, path);

          var arquivoVideo = ArquivoVideoDb(
            id: arquivoVideoDTO.id,
            provaId: provaId,
            questaoId: arquivoVideoDTO.questaoId,
            path: path,
          );

          await db.arquivosVideosDao.inserirOuAtualizar(arquivoVideo);
        }
      } catch (e) {
        severe("[Prova $provaId] - Erro ao baixar arquivo de vídeo ${arquivoVideoDTO.id} - ${e.toString()}");
        rethrow;
      }
    }
  }

  baixarArquivoAudio(List<ArquivoResponseDTO> audios) async {
    for (var arquivoAudioDTO in audios) {
      try {
        var arquivoAudioDb = await db.arquivosAudioDao.findById(arquivoAudioDTO.id);

        if (arquivoAudioDb == null) {
          String path = join(
            'prova',
            provaId.toString(),
            'audio',
            arquivoAudioDTO.questaoId.toString() + extension(arquivoAudioDTO.caminho),
          );

          await salvarArquivoLocal(arquivoAudioDTO.caminho, path);

          var arquivoAudio = ArquivoAudioDb(
            id: arquivoAudioDTO.id,
            provaId: provaId,
            questaoId: arquivoAudioDTO.questaoId,
            path: path,
          );

          await db.arquivosAudioDao.inserirOuAtualizar(arquivoAudio);
        }
      } catch (e) {
        severe("[Prova $provaId] - Erro ao baixar arquivo de áudio ${arquivoAudioDTO.id} - ${e.toString()}");
        rethrow;
      }
    }
  }

  salvarArquivoLocal(String url, String path) async {
    Uint8List contentes = await http.readBytes(Uri.parse(
      url.replaceFirst('http://', 'https://'),
    ));

    await saveFile(path, contentes);
  }

  _updateDownloadStatus(DownloadProvaDb download, EnumDownloadStatus status) async {
    await db.downloadProvaDao.updateStatus(download, status);
  }

  _updateProvaDownloadStatus(int provaId, EnumDownloadStatus status) async {
    await db.provaDao.updateDownloadStatus(provaId, status);
    provaStore?.downloadStatus = status;
  }

  _updateProvaDownloadId(int provaId, int downloadId) async {
    await db.provaDao.updateDownloadId(provaId, downloadId);
    provaStore?.prova.idDownload = downloadId;
  }

  _validarProva() async {
    var downloads = await db.downloadProvaDao.getByProva(provaId);

    if ((await getDownlodsByStatus(EnumDownloadStatus.ERRO)).isNotEmpty) {
      throw ProvaDownloadException(
          provaId, "Não foi possível baixar todo o conteúdo da prova ${provaStore?.prova.descricao ?? 'id: $provaId'}");
    } else if ((await getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO)).length == downloads.length) {
      // Validar quantidade de alternativa das questões
      await _validarQuestoes();
      await _validarArquivosImagem();

      info('[Prova $provaId] - Download concluido');

      await _updateProvaDownloadStatus(provaId, EnumDownloadStatus.CONCLUIDO);

      try {
        int idDownload = await informarDownloadConcluido(provaId);

        await _updateProvaDownloadId(provaId, idDownload);
      } catch (e, stack) {
        severe('[Prova $provaId] - Erro ao informar download concluido');
        severe(e);
        severe(stack);
      }

      cancelTimer();
      await deleteDownload();

      await atualizarStatus(downloads, EnumDownloadStatus.CONCLUIDO);
    }
  }

  Future<void> atualizarStatus(List<DownloadProvaDb> downloads, EnumDownloadStatus status) async {
    double porcentagem = await getPorcentagem(downloads);

    if (onStatusChangeCallback != null) {
      onStatusChangeCallback!(
        status,
        porcentagem,
        getTempoPrevisto(downloads),
      );
    }
    fine("[Prova $provaId] - Porcentagem concluida: ${(porcentagem * 100).toStringAsFixed(2)}%");
  }

  deleteDownload() async {
    await db.downloadProvaDao.deleteByProva(provaId);
  }

  _validarQuestoes() async {
    var questoes = await db.questaoDao.obterQuestoesPorProvaId(provaId);

    for (var questao in questoes) {
      var alternativas = await db.alternativaDao.obterPorQuestaoId(questao.id);
      switch (questao.tipo) {
        case EnumTipoQuestao.MULTIPLA_ESCOLHA:
          if (alternativas.length != questao.quantidadeAlternativas) {
            throw ProvaDownloadException(
              provaId,
              'Questão ${questao.id} deve conter ${questao.quantidadeAlternativas} alternatias, mas contem ${alternativas.length} alternativas',
            );
          }

          break;

        case EnumTipoQuestao.RESPOSTA_CONTRUIDA:
          if (alternativas.isNotEmpty) {
            throw ProvaDownloadException(
              provaId,
              'Questão ${questao.id} não deve conter nenhuma alternativa',
            );
          }
          break;

        case EnumTipoQuestao.NAO_CADASTRADO:
          break;
      }
    }
  }

  _validarArquivosImagem() async {
    var arquivosImagem = await db.arquivoDao.obterPorProvaId(provaId);

    for (var arquivo in arquivosImagem) {
      if (arquivo.base64.isEmpty) {
        throw ProvaDownloadException(
          provaId,
          'Arquivo ${arquivo.id} não possui cache salvo',
        );
      }
    }
  }
}
