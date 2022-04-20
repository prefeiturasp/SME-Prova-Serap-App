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
import 'package:appserap/dtos/questao.response.dto.dart';
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
  ProvaStore provaStore;

  AppDatabase db = ServiceLocator.get();
  ApiService apiService = ServiceLocator.get();

  // late List<DownloadProvaDb> downloads;

  late DateTime inicio;
  late int downloadAtual;
  bool _isPauseAllDownloads = false;

  StatusChangeCallback? onStatusChangeCallback;

  Timer? timer;
  TempoPrevistoChangeCallback? onTempoPrevistoChangeCallback;

  _DownloadManagerStoreBase(this.provaStore);

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
        retryIf: (e) => e is Exception,
        onRetry: (e) {
          fine('[Prova ${provaStore.id}] - Tentativa de download da prova');
          severe(e);
        },
      );
    } on ProvaDownloadException catch (e) {
      NotificacaoUtil.showSnackbarError(e.toString());
      await _updateProvaDownloadStatus(provaStore.id, EnumDownloadStatus.ERRO);
    } on Exception catch (e, stacktrace) {
      NotificacaoUtil.showSnackbarError("Não foi possível baixar a prova ${provaStore.prova.descricao}");
      await _updateProvaDownloadStatus(provaStore.id, EnumDownloadStatus.NAO_INICIADO);
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
      await db.downloadProvaDAO.inserirOuAtualizar(download);
    }

    // carregar do banco
    var downloads = await db.downloadProvaDAO.getByProva(provaStore.id);

    info(' [Prova ${provaStore.id}] - Carregando informações da prova');
    // carregar da url
    var response = await ServiceLocator.get<ApiService>().prova.getResumoProva(idProva: provaStore.id);

    if (!response.isSuccessful) {
      return;
    }

    ProvaDetalhesResponseDTO provaDetalhes = response.body!;

    // adcionar o que nao tem no banco
    info(" [Prova ${provaStore.id}] - Adicionando downloads da prova - Questão");
    for (var idQuestao in provaDetalhes.questoesId) {
      if (!_containsId(downloads, idQuestao, EnumDownloadTipo.QUESTAO)) {
        await salvarBanco(
          DownloadProvaDb(
            id: idQuestao,
            provaId: provaStore.id,
            tipo: EnumDownloadTipo.QUESTAO,
            downloadStatus: EnumDownloadStatus.NAO_INICIADO,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    info(" [Prova ${provaStore.id}] - Adicionando downloads da prova - Alternativas");
    for (var idAlternativa in provaDetalhes.alternativasId) {
      if (!_containsId(downloads, idAlternativa, EnumDownloadTipo.ALTERNATIVA)) {
        await salvarBanco(
          DownloadProvaDb(
            id: idAlternativa,
            provaId: provaStore.id,
            tipo: EnumDownloadTipo.ALTERNATIVA,
            downloadStatus: EnumDownloadStatus.NAO_INICIADO,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    info(" [Prova ${provaStore.id}] - Adicionando downloads da prova - Arquivos de imagem");
    for (var idArquivo in provaDetalhes.arquivosId) {
      if (!_containsId(downloads, idArquivo, EnumDownloadTipo.ARQUIVO)) {
        await salvarBanco(
          DownloadProvaDb(
            id: idArquivo,
            provaId: provaStore.id,
            tipo: EnumDownloadTipo.ARQUIVO,
            downloadStatus: EnumDownloadStatus.NAO_INICIADO,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    info(" [Prova ${provaStore.id}] - Adicionando downloads da prova - Arquivos de video");
    for (var idArquivoVideo in provaDetalhes.videosId) {
      if (!_containsId(downloads, idArquivoVideo, EnumDownloadTipo.VIDEO)) {
        await salvarBanco(
          DownloadProvaDb(
            id: idArquivoVideo,
            provaId: provaStore.id,
            tipo: EnumDownloadTipo.VIDEO,
            downloadStatus: EnumDownloadStatus.NAO_INICIADO,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    info(" [Prova ${provaStore.id}] - Adicionando downloads da prova - Arquivos de audio");
    for (var idArquivoAudio in provaDetalhes.audiosId) {
      if (!_containsId(downloads, idArquivoAudio, EnumDownloadTipo.AUDIO)) {
        await salvarBanco(
          DownloadProvaDb(
            id: idArquivoAudio,
            provaId: provaStore.id,
            tipo: EnumDownloadTipo.AUDIO,
            downloadStatus: EnumDownloadStatus.NAO_INICIADO,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    info(" [Prova ${provaStore.id}] - Adicionando downloads da prova - Contexto da prova");
    for (var idContexto in provaDetalhes.contextoProvaIds) {
      if (!_containsId(downloads, idContexto, EnumDownloadTipo.CONTEXTO_PROVA)) {
        await salvarBanco(
          DownloadProvaDb(
            id: idContexto,
            provaId: provaStore.id,
            tipo: EnumDownloadTipo.CONTEXTO_PROVA,
            downloadStatus: EnumDownloadStatus.NAO_INICIADO,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    downloads = await db.downloadProvaDAO.getByProva(provaStore.id);

    info('''[Prova ${provaStore.id}] - Carregando informações da prova - Finalizado

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
    var downloads = await db.downloadProvaDAO.getByProva(provaStore.id);

    var downloadsNaoConcluidos =
        downloads.filter((element) => element.downloadStatus != EnumDownloadStatus.CONCLUIDO).toList();

    downloadAtual = downloads.length - (await getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO, downloads)).length;
    inicio = DateTime.now();

    downloads.sort((a, b) => a.tipo.order.compareTo(b.tipo.order));

    info(" [Prova ${provaStore.id}] - Iniciando download da prova - ${downloadsNaoConcluidos.length} não concluidos");

    startTimer();

    for (int i = 1; i <= downloadsNaoConcluidos.length; i++) {
      var download = downloadsNaoConcluidos[i - 1];
      info('[Prova ${provaStore.id}] - Iniciando download  ${download.id} - ${download.tipo}');

      try {
        if (_isPauseAllDownloads) {
          info("[Prova ${provaStore.id}] - Pausando todos os downloads");
          await _pause();
          break;
        }

        if (onStatusChangeCallback != null) {
          onStatusChangeCallback!(
            EnumDownloadStatus.BAIXANDO,
            await getPorcentagem(downloads),
            getTempoPrevisto(downloads),
          );
        }

        switch (download.tipo) {
          case EnumDownloadTipo.QUESTAO:
            await retry(
              () async => await baixarQuestao(download),
              maxAttempts: 3,
              retryIf: (e) => e is Exception,
              onRetry: (e) {
                fine('[Prova ${provaStore.id}] - Tentativa de download da Questão ID: ${download.id}');
                severe(e);
              },
            );

            break;

          case EnumDownloadTipo.ALTERNATIVA:
            await retry(
              () async => await baixarAlternativa(download),
              maxAttempts: 3,
              retryIf: (e) => e is Exception,
              onRetry: (e) {
                fine('[Prova ${provaStore.id}] - Tentativa de download da Alternativa ID: ${download.id}');
                severe(e);
              },
            );
            break;

          case EnumDownloadTipo.CONTEXTO_PROVA:
            await retry(
              () async => await baixarContextoProva(download),
              maxAttempts: 3,
              retryIf: (e) => e is Exception,
              onRetry: (e) {
                fine('[Prova ${provaStore.id}] - Tentativa de download do Contexto ID: ${download.id}');
                severe(e);
              },
            );
            break;

          case EnumDownloadTipo.VIDEO:
            await retry(
              () async => await baixarArquivoVideo(download),
              maxAttempts: 3,
              retryIf: (e) => e is Exception,
              onRetry: (e) {
                fine('[Prova ${provaStore.id}] - Tentativa de download do arquivo de Video ID: ${download.id}');
                severe(e);
              },
            );

            break;

          case EnumDownloadTipo.AUDIO:
            await retry(
              () async => await baixarArquivoAudio(download),
              maxAttempts: 3,
              retryIf: (e) => e is Exception,
              onRetry: (e) {
                fine('[Prova ${provaStore.id}] - Tentativa de download do arquivo de Audio ID: ${download.id}');
                severe(e);
              },
            );

            break;

          case EnumDownloadTipo.ARQUIVO:
            await retry(
              () async => await baixarArquivoImagem(download),
              maxAttempts: 3,
              retryIf: (e) => e is Exception,
              onRetry: (e) {
                fine('[Prova ${provaStore.id}] - Tentativa de download do arquivo de Imagem ID: ${download.id}');
                severe(e);
              },
            );
            break;
        }

        downloadAtual = i;
      } on Exception catch (e, stack) {
        severe('[Prova ${provaStore.id}] - ERRO: $e');
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
      var downloads = await db.downloadProvaDAO.getByProva(provaStore.id);

      int downloadsPendentes = 0;

      for (var download in downloads) {
        if (download.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
          await _updateDownloadStatus(download, EnumDownloadStatus.PAUSADO);
          downloadsPendentes++;
        }
      }

      await _updateProvaDownloadStatus(provaStore.id, EnumDownloadStatus.PAUSADO);

      info("[Prova ${provaStore.id}] - Download pausado - $downloadsPendentes pendentes");
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
        var downloads = await db.downloadProvaDAO.getByProva(provaStore.id);
        onTempoPrevistoChangeCallback!(getTempoPrevisto(downloads));
      }
    });
  }

  cancelTimer() {
    timer?.cancel();
  }

  Future<double> getPorcentagem(List<DownloadProvaDb> downloads) async {
    var downloadsDb = await db.downloadProvaDAO.getByProva(provaStore.id);
    int baixado = downloadsDb.where((element) => element.downloadStatus == EnumDownloadStatus.CONCLUIDO).length;

    return baixado / downloads.length;
  }

  double getTempoPrevisto(List<DownloadProvaDb> downloads) {
    return (downloads.length - downloadAtual) / (downloadAtual / (DateTime.now().difference(inicio).inSeconds));
  }

  Future<List<DownloadProvaDb>> getDownlodsByStatus(EnumDownloadStatus status,
      [List<DownloadProvaDb>? downloads]) async {
    downloads ??= await db.downloadProvaDAO.getByProva(provaStore.id);
    return downloads.where((element) => element.downloadStatus == status).toList();
  }

  baixarQuestao(DownloadProvaDb download) async {
    await _updateDownloadStatus(download, EnumDownloadStatus.BAIXANDO);

    Response<QuestaoResponseDTO> response = await apiService.questao.getQuestao(idQuestao: download.id);

    if (response.isSuccessful) {
      QuestaoResponseDTO questaoDTO = response.body!;

      var questao = QuestaoDb(
        id: questaoDTO.id,
        titulo: questaoDTO.titulo,
        descricao: questaoDTO.descricao,
        ordem: questaoDTO.ordem,
        tipo: questaoDTO.tipo,
        provaId: provaStore.id,
        quantidadeAlternativas: questaoDTO.quantidadeAlternativas,
      );

      await db.questaoDAO.inserirOuAtualizar(questao);
    }

    await _updateDownloadStatus(download, EnumDownloadStatus.CONCLUIDO);
  }

  baixarAlternativa(DownloadProvaDb download) async {
    await _updateDownloadStatus(download, EnumDownloadStatus.BAIXANDO);

    Response<AlternativaResponseDTO> response = await apiService.alternativa.getAlternativa(idAlternativa: download.id);

    if (response.isSuccessful) {
      AlternativaResponseDTO alternativaDTO = response.body!;

      AlternativaDb alternativa = AlternativaDb(
        id: alternativaDTO.id,
        provaId: provaStore.id,
        descricao: alternativaDTO.descricao,
        ordem: alternativaDTO.ordem,
        numeracao: alternativaDTO.numeracao,
        questaoId: alternativaDTO.questaoId,
      );

      db.alternativaDAO.inserirOuAtualizar(alternativa);

      await _updateDownloadStatus(download, EnumDownloadStatus.CONCLUIDO);
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

      await db.contextoProvaDAO.inserirOuAtualizar(contextoProva);

      await _updateDownloadStatus(download, EnumDownloadStatus.CONCLUIDO);
    }
  }

  baixarArquivoImagem(DownloadProvaDb download) async {
    await _updateDownloadStatus(download, EnumDownloadStatus.BAIXANDO);

    Response<ArquivoResponseDTO> response = await apiService.arquivo.getArquivo(idArquivo: download.id);

    if (response.isSuccessful) {
      QuestaoDb? questao = await db.questaoDAO.obterQuestaoPorArquivoLegadoId(download.id, provaStore.id);

      questao ??= await db.questaoDAO.obterQuestaoPorArquivoLegadoIdAlternativa(download.id, provaStore.id);

      ArquivoResponseDTO arquivoDTO = response.body!;

      http.Response arquivoResponse = await http.get(
        Uri.parse(
          arquivoDTO.caminho.replaceFirst('http://', 'https://'),
        ),
      );

      if (arquivoResponse.statusCode == 200) {
        String base64 = base64Encode(arquivoResponse.bodyBytes);

        var arquivo = ArquivoDb(
          id: int.parse("${arquivoDTO.id}${arquivoDTO.questaoId}"),
          provaId: provaStore.id,
          legadoId: arquivoDTO.id,
          caminho: arquivoDTO.caminho,
          base64: base64,
          questaoId: questao!.id,
        );

        await db.arquivoDAO.inserirOuAtualizar(arquivo);

        await _updateDownloadStatus(download, EnumDownloadStatus.CONCLUIDO);
      } else {
        await _updateDownloadStatus(download, EnumDownloadStatus.ERRO);
        severe(
            "[Prova ${provaStore.id}] - Erro ao baixar arquivo ${arquivoDTO.id} - Status ${arquivoResponse.statusCode}");
      }
    } else {
      await _updateDownloadStatus(download, EnumDownloadStatus.ERRO);
    }
  }

  baixarArquivoVideo(DownloadProvaDb download) async {
    try {
      await _updateDownloadStatus(download, EnumDownloadStatus.BAIXANDO);

      Response<ArquivoVideoResponseDTO> response = await apiService.arquivo.getVideo(idArquivo: download.id);

      if (response.isSuccessful) {
        ArquivoVideoResponseDTO arquivo = response.body!;

        String path = join(
          'prova',
          provaStore.id.toString(),
          'video',
          arquivo.questaoId.toString() + extension(arquivo.caminho),
        );

        await salvarArquivoLocal(arquivo.caminho, path);

        var arquivoVideo = ArquivoVideoDb(
          id: arquivo.id,
          provaId: provaStore.id,
          questaoId: arquivo.questaoId,
          path: path,
        );

        await db.arquivosVideosDao.inserirOuAtualizar(arquivoVideo);

        await _updateDownloadStatus(download, EnumDownloadStatus.CONCLUIDO);
      } else {
        await _updateDownloadStatus(download, EnumDownloadStatus.ERRO);
      }
    } on Exception {
      await _updateDownloadStatus(download, EnumDownloadStatus.ERRO);
      rethrow;
    }
  }

  baixarArquivoAudio(DownloadProvaDb download) async {
    try {
      await _updateDownloadStatus(download, EnumDownloadStatus.BAIXANDO);

      Response<ArquivoResponseDTO> response = await apiService.arquivo.getAudio(idArquivo: download.id);

      if (response.isSuccessful) {
        ArquivoResponseDTO arquivo = response.body!;

        String path = join(
          'prova',
          provaStore.id.toString(),
          'audio',
          arquivo.questaoId.toString() + extension(arquivo.caminho),
        );

        await salvarArquivoLocal(arquivo.caminho, path);

        var arquivoAudio = ArquivoAudioDb(
          id: arquivo.id,
          provaId: provaStore.id,
          questaoId: arquivo.questaoId,
          path: path,
        );

        await db.arquivosAudioDao.inserirOuAtualizar(arquivoAudio);

        await _updateDownloadStatus(download, EnumDownloadStatus.CONCLUIDO);
      } else {
        await _updateDownloadStatus(download, EnumDownloadStatus.ERRO);
      }
    } on Exception catch (e) {
      await _updateDownloadStatus(download, EnumDownloadStatus.ERRO);
      rethrow;
    }
  }

  salvarArquivoLocal(String url, String path) async {
    Uint8List contentes = await http.readBytes(Uri.parse(
      url.replaceFirst('http://', 'https://'),
    ));

    await saveFile(path, contentes);
  }

  _updateDownloadStatus(DownloadProvaDb download, EnumDownloadStatus status) async {
    await db.downloadProvaDAO.updateStatus(download, status);
  }

  _updateProvaDownloadStatus(int provaId, EnumDownloadStatus status) async {
    await db.provaDAO.updateDownloadStatus(provaId, status);
    provaStore.downloadStatus = status;
  }

  _updateProvaDownloadId(int provaId, int downloadId) async {
    await db.provaDAO.updateDownloadId(provaId, downloadId);
    provaStore.prova.idDownload = downloadId;
  }

  _validarProva() async {
    var downloads = await db.downloadProvaDAO.getByProva(provaStore.id);

    if ((await getDownlodsByStatus(EnumDownloadStatus.ERRO)).isNotEmpty) {
      throw ProvaDownloadException(
          provaStore.id, "Não foi possível baixar todo o conteúdo da prova '${provaStore.prova.descricao}'");
    } else if ((await getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO)).length == downloads.length) {
      // Validar quantidade de alternativa das questões
      await _validarQuestoes();

      info('[Prova ${provaStore.id}] - Download concluido');

      await _updateProvaDownloadStatus(provaStore.id, EnumDownloadStatus.CONCLUIDO);

      try {
        int idDownload = await informarDownloadConcluido(provaStore.id);

        await _updateProvaDownloadId(provaStore.id, idDownload);
      } catch (e, stack) {
        severe('[Prova ${provaStore.id}] - Erro ao informar download concluido');
        severe(e);
        severe(stack);
      }

      cancelTimer();
      await deleteDownload();

      if (onStatusChangeCallback != null) {
        onStatusChangeCallback!(
          EnumDownloadStatus.CONCLUIDO,
          await getPorcentagem(downloads),
          getTempoPrevisto(downloads),
        );
      }
    }
  }

  deleteDownload() async {
    await db.downloadProvaDAO.deleteByProva(provaStore.id);
  }

  _validarQuestoes() async {
    var questoes = await db.questaoDAO.obterQuestoesPorProvaId(provaStore.id);

    for (var questao in questoes) {
      var alternativas = await db.alternativaDAO.obterPorQuestaoId(questao.id);
      switch (questao.tipo) {
        case EnumTipoQuestao.MULTIPLA_ESCOLHA:
          if (alternativas.length != questao.quantidadeAlternativas) {
            throw ProvaDownloadException(
              provaStore.id,
              'Questão ${questao.id} deve conter ${questao.quantidadeAlternativas} alternatias, mas contem ${alternativas.length} alternativas',
            );
          }

          break;

        case EnumTipoQuestao.RESPOSTA_CONTRUIDA:
          if (alternativas.isNotEmpty) {
            throw ProvaDownloadException(
              provaStore.id,
              'Questão ${questao.id} não deve conter nenhuma alternativa',
            );
          }
          break;

        case EnumTipoQuestao.NAO_CADASTRADO:
          break;
      }
    }
  }
}
