import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/arquivo_video.response.dto.dart';
import 'package:appserap/dtos/contexto_prova.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes_caderno.response.dto.dart';
import 'package:appserap/dtos/questao_detalhes_legado.response.dto.dart';
import 'package:appserap/enums/deficiencia.enum.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/exceptions/prova_download.exception.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:appserap/models/prova_caderno.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/models/questao_arquivo.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/notificacao.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/universal/universal.util.dart';
import 'package:chopper/chopper.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:appserap/utils/firebase.util.dart';
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
  late String caderno;

  AppDatabase db = ServiceLocator.get();
  ApiService apiService = ServiceLocator.get();

  // late List<DownloadProvaDb> downloads;

  late DateTime inicio;
  late int downloadAtual;
  bool _isPauseAllDownloads = false;
  var quantidadeDownloads = 2;

  StatusChangeCallback? onStatusChangeCallback;

  Timer? timer;
  TempoPrevistoChangeCallback? onTempoPrevistoChangeCallback;

  _DownloadManagerStoreBase({ProvaStore? provaStore, int? provaId, String? caderno}) {
    if (provaStore != null) {
      this.provaStore = provaStore;
      this.provaId = provaStore.id;
      this.caderno = provaStore.caderno;
    } else {
      this.provaId = provaId!;
      this.caderno = caderno!;
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
    } on ProvaDownloadException catch (e, stack) {
      NotificacaoUtil.showSnackbarError(e.toString());
      await _updateProvaDownloadStatus(provaId, EnumDownloadStatus.ERRO);
      await recordError(e, stack);
    } on Exception catch (e, stack) {
      NotificacaoUtil.showSnackbarError(
          "Não foi possível baixar a prova ${provaStore?.prova.descricao ?? 'id: $provaId'}");
      await _updateProvaDownloadStatus(provaId, EnumDownloadStatus.NAO_INICIADO);
      await recordError(e, stack);
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
    var response = await ServiceLocator.get<ApiService>().prova.getResumoProvaCaderno(
          idProva: provaId,
          caderno: caderno,
        );

    if (!response.isSuccessful) {
      return;
    }

    ProvaDetalhesCadernoResponseDTO provaDetalhes = response.body!;

    // adcionar o que nao tem no banco
    info(" [Prova $provaId] - Adicionando downloads da prova - Questão");
    for (var questao in provaDetalhes.questoes) {
      if (!_containsId(downloads, questao.questaoLegadoId, EnumDownloadTipo.QUESTAO)) {
        await salvarBanco(
          DownloadProvaDb(
            id: questao.questaoId,
            questaoLegadoId: questao.questaoLegadoId,
            provaId: provaId,
            ordem: questao.ordem,
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

    var downloadsQuestao =
        downloadsNaoConcluidos.filter((element) => element.tipo == EnumDownloadTipo.QUESTAO).toList();
    var downloadsContexto =
        downloadsNaoConcluidos.filter((element) => element.tipo == EnumDownloadTipo.CONTEXTO_PROVA).toList();

    for (int i = 0; i < downloadsQuestao.length; i = i + quantidadeDownloads) {
      if (_isPauseAllDownloads) {
        info("[Prova $provaId] - Pausando todos os downloads");
        await _pause();
        return;
      }

      var end = i + quantidadeDownloads;
      end = end > downloadsQuestao.length ? downloadsQuestao.length : end;

      info('Baixando do $i ate $end');
      var downloads = downloadsNaoConcluidos.getRange(i, end).toList();
      info('Baixando as questões ${downloads.map((e) => e.id).toList()}');

      await atualizarStatus(EnumDownloadStatus.BAIXANDO);

      await salvarQuestao(downloads);

      downloadAtual = i + quantidadeDownloads;
    }

    for (var download in downloadsContexto) {
      if (_isPauseAllDownloads) {
        info("[Prova $provaId] - Pausando todos os contextos");
        await _pause();
        return;
      }

      await salvarContexto(download);
      await atualizarStatus(EnumDownloadStatus.BAIXANDO);
    }
  }

  salvarContexto(DownloadProvaDb download) async {
    finer('[Prova $provaId] - Iniciando download  ${download.id} - ${download.tipo}');

    try {
      await retry(
        () async => await baixarContextoProva(download),
        maxAttempts: 3,
        onRetry: (e) {
          fine('[Prova $provaId] - Tentativa de download do Contexto ID: ${download.id}');
          severe(e);
        },
      );
    } on Exception catch (e, stack) {
      severe('[Prova $provaId] - ERRO: $e');
      await recordError(e, stack);

      await _updateDownloadStatus(download, EnumDownloadStatus.ERRO);
    }
  }

  salvarQuestao(List<DownloadProvaDb> downloads) async {
    for (var download in downloads) {
      finer('[Prova $provaId] - Iniciando download  ${download.id} - ${download.tipo}');
    }

    try {
      await retry(
        () async => await baixarQuestao(downloads),
        maxAttempts: 3,
        onRetry: (e) {
          fine('[Prova $provaId] - Tentativa de download das Questões ID: ${downloads.map((e) => e.id).toList()}');
          severe(e);
        },
      );
    } on Exception catch (e, stack) {
      severe('[Prova $provaId] - ERRO: $e');
      await recordError(e, stack);

      await _updateDownloadsStatus(downloads, EnumDownloadStatus.ERRO);
    }
  }

  Future<String> informarDownloadConcluido(int idProva) async {
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

    return "";
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

      var porcentagem = await getPorcentagem(downloads);

      info(
          "[Prova $provaId] - Download pausado ${(porcentagem * 100).toStringAsFixed(2)} - $downloadsPendentes pendentes");
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

  Future<double> getPorcentagem(List<DownloadProvaDb> downloadsDb) async {
    int baixado = downloadsDb.where((element) => element.downloadStatus == EnumDownloadStatus.CONCLUIDO).length;

    return baixado / downloadsDb.length;
  }

  double getTempoPrevisto(List<DownloadProvaDb> downloads) {
    return (downloads.length - downloadAtual) / (downloadAtual / (DateTime.now().difference(inicio).inSeconds));
  }

  Future<List<DownloadProvaDb>> getDownlodsByStatus(EnumDownloadStatus status,
      [List<DownloadProvaDb>? downloads]) async {
    downloads ??= await db.downloadProvaDao.getByProva(provaId);
    return downloads.where((element) => element.downloadStatus == status).toList();
  }

  baixarContextoProva(DownloadProvaDb download) async {
    await _updateDownloadStatus(download, EnumDownloadStatus.BAIXANDO);

    Response<ContextoProvaResponseDTO> response = await apiService.contextoProva.getContextoProva(id: download.id);

    if (response.isSuccessful) {
      ContextoProvaResponseDTO contexto = response.body!;

      http.Response contextoResponse = await http.get(
        Uri.parse(
          contexto.imagem.replaceFirst('http://', 'https://'),
        ),
      );

      String base64 = base64Encode(contextoResponse.bodyBytes);

      var contextoProva = ContextoProva(
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

  baixarQuestao(List<DownloadProvaDb> downloads) async {
    await _updateDownloadsStatus(downloads, EnumDownloadStatus.BAIXANDO);

    try {
      Response<List<QuestaoDetalhesLegadoResponseDTO>> response = await apiService.questao
          .getQuestaoCompletaLegado(idsLegado: downloads.map((e) => e.questaoLegadoId!).toList());

      if (response.isSuccessful) {
        List<QuestaoDetalhesLegadoResponseDTO> questoesDTO = response.body!;

        if (questoesDTO.isEmpty) {
          await _updateDownloadsStatus(downloads, EnumDownloadStatus.ERRO);
          return;
        }

        for (QuestaoDetalhesLegadoResponseDTO questaoDTO in questoesDTO) {
          // verificar se a questao ja esta no banco
          var questaoDb = await db.questaoDao.getByQuestaoLegadoId(questaoDTO.questaoLegadoId);

          if (questaoDb == null) {
            severe("[Prova $provaId] - Salvando questao ${questaoDTO.id}");

            var questao = Questao(
              questaoLegadoId: questaoDTO.questaoLegadoId,
              titulo: questaoDTO.titulo,
              descricao: questaoDTO.descricao,
              tipo: questaoDTO.tipo,
              quantidadeAlternativas: questaoDTO.quantidadeAlternativas,
            );

            await db.questaoDao.inserirOuAtualizar(questao);

            await baixarAlternativa(questaoDTO.alternativas, questaoDTO.questaoLegadoId);

            if (questaoDTO.arquivos.isNotEmpty) {
              await baixarArquivoImagem(questaoDTO.arquivos, questaoDTO.questaoLegadoId);
            }

            var deficnencias = ServiceLocator.get<UsuarioStore>().deficiencias;

            for (var deficiencia in deficnencias) {
              if (grupoSurdos.contains(deficiencia)) {
                await baixarArquivoVideo(questaoDTO.videos, questaoDTO.questaoLegadoId);
                break;
              }
            }

            for (var deficiencia in deficnencias) {
              if (grupoCegos.contains(deficiencia)) {
                await baixarArquivoAudio(questaoDTO.audios, questaoDTO.questaoLegadoId);
                break;
              }
            }
          } else {
            severe("[Prova $provaId] - Questao ${questaoDTO.id} ja existe no banco");
          }

          DownloadProvaDb download = downloads
              .where(
                (element) => element.questaoLegadoId == questaoDTO.questaoLegadoId,
              )
              .first;

          var provaCaderno = ProvaCaderno(
            questaoId: download.id,
            questaoLegadoId: questaoDTO.questaoLegadoId,
            provaId: provaId,
            caderno: caderno,
            ordem: download.ordem!,
          );

          // salva referencia prova caderno questao
          await db.provaCadernoDao.inserirOuAtualizar(provaCaderno);
        }

        await _updateDownloadsStatus(downloads, EnumDownloadStatus.CONCLUIDO);
      } else {
        await _updateDownloadsStatus(downloads, EnumDownloadStatus.ERRO);
      }
    } catch (e, stack) {
      await _updateDownloadsStatus(downloads, EnumDownloadStatus.ERRO);
      severe('[Prova $provaId] - ERRO: $e');
      await recordError(e, stack);
    }
  }

  baixarAlternativa(List<AlternativaResponseDTO> alternativas, int questaoLegadoId) async {
    finer("[Prova $provaId] - Salvando ${alternativas.length} alternativas");

    for (var alternativaDTO in alternativas) {
      Alternativa alternativaDb = Alternativa(
        id: alternativaDTO.id,
        questaoLegadoId: questaoLegadoId,
        descricao: alternativaDTO.descricao,
        ordem: alternativaDTO.ordem,
        numeracao: alternativaDTO.numeracao,
      );

      await db.alternativaDao.inserirOuAtualizar(alternativaDb);
    }
  }

  baixarArquivoImagem(List<ArquivoResponseDTO> arquivos, int questaoLegadoId) async {
    finer("[Prova $provaId] - Salvando ${arquivos.length} arquivos de imagem");

    for (var arquivoDTO in arquivos) {
      try {
        Arquivo? arquivoDb;
        try {
          arquivoDb = await db.arquivoDao.findByLegadoId(arquivoDTO.legadoId);
        } catch (e, stack) {
          await recordError(e, stack);
        }

        if (arquivoDb == null) {
          http.Response arquivoResponse = await http.get(
            Uri.parse(
              arquivoDTO.caminho.replaceFirst('http://', 'https://'),
            ),
          );

          if (arquivoResponse.statusCode == 200) {
            String base64 = base64Encode(arquivoResponse.bodyBytes);

            var arquivo = Arquivo(
              id: int.parse("${arquivoDTO.id}${arquivoDTO.questaoId}"),
              legadoId: arquivoDTO.legadoId,
              caminho: arquivoDTO.caminho,
              base64: base64,
            );

            await db.arquivoDao.inserirOuAtualizar(arquivo);

            fine("[Prova $provaId] - Arquivo salvo: ${arquivo.caminho}");
          } else {
            severe("[Prova $provaId] - Erro ao baixar arquivo ${arquivoDTO.id} - Status ${arquivoResponse.statusCode}");
          }
        }

        // Vincular questao ao arquivo
        var questaoArquivo = QuestaoArquivo(
          questaoLegadoId: questaoLegadoId,
          arquivoLegadoId: arquivoDTO.legadoId,
        );

        await db.questaoArquivoDao.inserirOuAtualizar(questaoArquivo);
      } catch (e) {
        severe("[Prova $provaId] - Erro ao baixar arquivo de imagem ${arquivoDTO.id} - ${e.toString()}");

        rethrow;
      }
    }
  }

  baixarArquivoVideo(List<ArquivoVideoResponseDTO> videos, int questaoLegadoId) async {
    finer("[Prova $provaId] - Salvando ${videos.length} arquivos de video");

    for (var arquivoVideoDTO in videos) {
      try {
        var arquivoVideoDb = await db.arquivosVideosDao.findByQuestaoLegadoId(questaoLegadoId);

        String path = join(
          'prova',
          provaId.toString(),
          'video',
          arquivoVideoDTO.questaoId.toString() + extension(arquivoVideoDTO.caminho),
        );

        if (arquivoVideoDb == null || !(await fileExists(path))) {
          await salvarArquivoLocal(arquivoVideoDTO.caminho, path);

          var arquivoVideo = ArquivoVideoDb(
            id: arquivoVideoDTO.id,
            questaoLegadoId: questaoLegadoId,
            path: path,
          );

          await db.arquivosVideosDao.inserirOuAtualizar(arquivoVideo);

          fine("[Prova $provaId] - Arquivo salvo: ${arquivoVideoDTO.caminho}");
        }
      } catch (e) {
        severe("[Prova $provaId] - Erro ao baixar arquivo de vídeo ${arquivoVideoDTO.id} - ${e.toString()}");

        rethrow;
      }
    }
  }

  baixarArquivoAudio(List<ArquivoResponseDTO> audios, int questaoLegadoId) async {
    finer("[Prova $provaId] - Salvando ${audios.length} arquivos de audio");

    for (var arquivoAudioDTO in audios) {
      try {
        var arquivoAudioDb = await db.arquivosAudioDao.findByQuestaoLegadoId(questaoLegadoId);

        String path = join(
          'prova',
          provaId.toString(),
          'audio',
          arquivoAudioDTO.questaoId.toString() + extension(arquivoAudioDTO.caminho),
        );

        if (arquivoAudioDb == null || !(await fileExists(path))) {
          await salvarArquivoLocal(arquivoAudioDTO.caminho, path);

          var arquivoAudio = ArquivoAudioDb(
            id: arquivoAudioDTO.id,
            questaoLegadoId: questaoLegadoId,
            path: path,
          );

          await db.arquivosAudioDao.inserirOuAtualizar(arquivoAudio);

          fine("[Prova $provaId] - Arquivo salvo: ${arquivoAudioDTO.caminho}");
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

  _updateDownloadsStatus(List<DownloadProvaDb> downloads, EnumDownloadStatus status) async {
    for (var download in downloads) {
      await db.downloadProvaDao.updateStatus(download, status);
    }
  }

  _updateDownloadStatus(DownloadProvaDb download, EnumDownloadStatus status) async {
    await db.downloadProvaDao.updateStatus(download, status);
  }

  _updateProvaDownloadStatus(int provaId, EnumDownloadStatus status) async {
    await db.provaDao.updateDownloadStatus(provaId, status);
    provaStore?.downloadStatus = status;
  }

  _updateProvaDownloadId(int provaId, String downloadId) async {
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
        String idDownload = await informarDownloadConcluido(provaId);

        await _updateProvaDownloadId(provaId, idDownload);
      } catch (e, stack) {
        severe('[Prova $provaId] - Erro ao informar download concluido');
        await recordError(e, stack, reason: "Erro ao informar download concluido");
      }

      cancelTimer();
      await deleteDownload();

      await atualizarStatus(EnumDownloadStatus.CONCLUIDO);
    }
  }

  Future<void> atualizarStatus(EnumDownloadStatus status) async {
    var downloadsDb = await db.downloadProvaDao.getByProva(provaId);

    double porcentagem = await getPorcentagem(downloadsDb);

    if (onStatusChangeCallback != null) {
      onStatusChangeCallback!(
        status,
        porcentagem,
        getTempoPrevisto(downloadsDb),
      );
    }
  }

  deleteDownload() async {
    await db.downloadProvaDao.deleteByProva(provaId);
  }

  _validarQuestoes() async {
    var questoes = await db.questaoDao.obterPorProvaECaderno(provaId, caderno);

    for (var questao in questoes) {
      var alternativas = await db.alternativaDao.obterPorQuestaoLegadoId(questao.questaoLegadoId);
      switch (questao.tipo) {
        case EnumTipoQuestao.MULTIPLA_ESCOLHA:
          if (alternativas.length != questao.quantidadeAlternativas) {
            throw ProvaDownloadException(
              provaId,
              'Questão ${questao.questaoLegadoId} deve conter ${questao.quantidadeAlternativas} alternatias, mas contem ${alternativas.length} alternativas',
            );
          }

          break;

        case EnumTipoQuestao.RESPOSTA_CONTRUIDA:
          if (alternativas.isNotEmpty) {
            throw ProvaDownloadException(
              provaId,
              'Questão ${questao.questaoLegadoId} não deve conter nenhuma alternativa',
            );
          }
          break;

        case EnumTipoQuestao.NAO_CADASTRADO:
          break;
      }
    }
  }

  _validarArquivosImagem() async {
    var arquivosImagem = await db.arquivoDao.findByProvaECaderno(provaId, caderno);

    for (var arquivo in arquivosImagem) {
      if (arquivo.base64.isEmpty) {
        throw ProvaDownloadException(
          provaId,
          'Arquivo ${arquivo.id} não possui cache salvo',
        );
      }
    }
  }

  removerDownloadCompleto([bool manterRegistroProva = false]) async {
    info('[$provaId] Removendo conteudo da prova');

    await removerContexto(provaId);

    await removerQuestoes(provaId);

    if (!manterRegistroProva) {
      await removerCacheAluno(provaId);
      await removerProva(provaId);
      await removerProvaCaderno(provaId);
    }
  }

  removerContexto(int provaId) async {
    int total = await db.contextoProvaDao.removerPorProvaId(provaId);
    info("[Prova $provaId - Removido $total contextos");
  }

  removerQuestoes(int provaId) async {
    var questoes = await db.questaoDao.obterPorProvaId(provaId);

    for (var questao in questoes) {
      await removerAlternativas(questao.questaoLegadoId);
      await removerArquivosImagem(questao.questaoLegadoId);
      await removerArquivosAudio(questao.questaoLegadoId);
      await removerArquivosVideo(questao.questaoLegadoId);
    }

    int total = await db.questaoDao.removerPorProvaId(provaId);
    info("[Prova $provaId - Removido $total questoes");
  }

  removerAlternativas(int questaoLegadoId) async {
    int total = await db.alternativaDao.removerPorQuestaoLegadoId(provaId);
    info("[Prova $provaId - Removido $total alternativas");
  }

  removerArquivosImagem(int questaoLegadoId) async {
    var arquivos = await db.arquivoDao.obterPorQuestaoLegadoId(questaoLegadoId);

    for (var arquivo in arquivos) {
      fine("'Removendo arquivo de iamgem '${arquivo.caminho}'");
      await db.arquivoDao.remover(arquivo);
      await apagarArquivo(arquivo.caminho);
    }

    info("[Prova $provaId - Removido ${arquivos.length} arquivos de imagem");
  }

  removerArquivosAudio(int questaoLegadoId) async {
    var arquivo = await db.arquivosAudioDao.obterPorQuestaoLegadoId(questaoLegadoId);

    if (arquivo != null) {
      fine("'Removendo arquivo de video '${arquivo.path}'");
      await db.arquivosAudioDao.remover(arquivo);
      await apagarArquivo(arquivo.path);
    }
  }

  removerArquivosVideo(int questaoLegadoId) async {
    var arquivo = await db.arquivosVideosDao.obterPorQuestaoLegadoId(questaoLegadoId);

    if (arquivo != null) {
      fine("'Removendo arquivo de audio '${arquivo.path}'");
      await db.arquivosVideosDao.remover(arquivo);
      await apagarArquivo(arquivo.path);
    }
  }

  removerCacheAluno(int provaId) async {
    int total = await db.provaAlunoDao.removerPorProvaId(provaId);
    info("[Prova $provaId - Removido $total caches de provas");
  }

  removerProva(int provaId) async {
    await db.provaDao.deleteByProva(provaId);
  }

  removerProvaCaderno(int provaid) async {
    await db.provaCadernoDao.removerPorProvaId(provaId);
  }
}
