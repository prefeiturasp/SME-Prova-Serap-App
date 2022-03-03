import 'dart:async';
import 'dart:convert';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/arquivo_video.response.dto.dart';
import 'package:appserap/dtos/contexto_prova.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes.response.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/exceptions/prova_download.exception.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/arquivo_audio.model.dart';
import 'package:appserap/models/arquivo_video.model.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:appserap/models/download_prova.model.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/universal/universal.util.dart';
import 'package:chopper/src/response.dart';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef StatusChangeCallback = void Function(EnumDownloadStatus downloadStatus, double porcentagem);
typedef TempoPrevistoChangeCallback = void Function(double tempoPrevisto);

class GerenciadorDownload with Loggable {
  int idProva;
  List<DownloadProva> downloads = [];
  bool _isPauseAllDownloads = false;
  late DateTime inicio;
  late int downloadAtual;

  StatusChangeCallback? onChangeStatusCallback;
  TempoPrevistoChangeCallback? onTempoPrevistoChangeCallback;

  Timer? timer;

  GerenciadorDownload({
    required this.idProva,
  });

  pauseAllDownloads() {
    _isPauseAllDownloads = true;
  }

  Future<void> configure() async {
    try {
      await retry(
        () async => await carregarDadosProva(),
        retryIf: (e) => e is Exception,
        onRetry: (e) {
          fine(e);
          fine('[Prova $idProva] - Tentativa de Obter informações da prova');
        },
      );

      finer('** Total Downloads ${downloads.length}');
      finer('** Downloads concluidos ${getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO).length}');
      finer('** Downloads nao Iniciados ${getDownlodsByStatus(EnumDownloadStatus.NAO_INICIADO).length}');

      await saveDownloads();
    } catch (e) {
      //AsukaSnackbar.alert("Não foi possível obter os detalhes da prova").show();
      return;
    }
  }

  carregarDadosProva() async {
    Response<ProvaDetalhesResponseDTO> response =
        await ServiceLocator.get<ApiService>().prova.getResumoProva(idProva: idProva);

    if (!response.isSuccessful) {
      return;
    }

    ProvaDetalhesResponseDTO provaDetalhes = response.body!;

    await loadDownloads();

    for (var idQuestao in provaDetalhes.questoesId) {
      if (!containsId(idQuestao, EnumDownloadTipo.QUESTAO)) {
        downloads.add(
          DownloadProva(
            tipo: EnumDownloadTipo.QUESTAO,
            id: idQuestao,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    for (var idAlternativa in provaDetalhes.alternativasId) {
      if (!containsId(idAlternativa, EnumDownloadTipo.ALTERNATIVA)) {
        downloads.add(
          DownloadProva(
            tipo: EnumDownloadTipo.ALTERNATIVA,
            id: idAlternativa,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    for (var idArquivo in provaDetalhes.arquivosId) {
      if (!containsId(idArquivo, EnumDownloadTipo.ARQUIVO)) {
        downloads.add(
          DownloadProva(
            tipo: EnumDownloadTipo.ARQUIVO,
            id: idArquivo,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    for (var idArquivoVideo in provaDetalhes.videosId) {
      if (!containsId(idArquivoVideo, EnumDownloadTipo.VIDEO)) {
        downloads.add(
          DownloadProva(
            tipo: EnumDownloadTipo.VIDEO,
            id: idArquivoVideo,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    for (var idArquivoAudio in provaDetalhes.audiosId) {
      if (!containsId(idArquivoAudio, EnumDownloadTipo.AUDIO)) {
        downloads.add(
          DownloadProva(
            tipo: EnumDownloadTipo.AUDIO,
            id: idArquivoAudio,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }

    for (var idContexto in provaDetalhes.contextoProvaIds) {
      if (!containsId(idContexto, EnumDownloadTipo.CONTEXTO_PROVA)) {
        downloads.add(
          DownloadProva(
            tipo: EnumDownloadTipo.CONTEXTO_PROVA,
            id: idContexto,
            dataHoraInicio: DateTime.now(),
          ),
        );
      }
    }
  }

  onStatusChange(StatusChangeCallback onChangeStatusCallback) {
    this.onChangeStatusCallback = onChangeStatusCallback;
  }

  onTempoPrevistoChange(void Function(double tempoPrevisto) onTempoPrevistoChangeCallback) {
    this.onTempoPrevistoChangeCallback = onTempoPrevistoChangeCallback;
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (onTempoPrevistoChangeCallback != null) {
        onTempoPrevistoChangeCallback!(getTempoPrevisto());
      }
    });
  }

  cancelTimer() {
    timer?.cancel();
  }

  Future<void> startDownload() async {
    info('Iniciando download da prova ID $idProva');

    Prova prova = await getProva();

    downloadAtual = downloads.length - getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO).length;

    if (prova.downloadStatus == EnumDownloadStatus.CONCLUIDO) {
      return;
    }

    ApiService apiService = GetIt.I.get();

    inicio = DateTime.now();

    downloads.sort((a, b) => a.tipo.order.compareTo(b.tipo.order));

    for (var i = 0; i < downloads.length; i++) {
      var download = downloads[i];

      if (_isPauseAllDownloads) {
        await _pause();
        break;
      }

      if (download.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
        fine('[Prova $idProva] - Iniciando download TIPO: ${download.tipo} ID: ${download.id}');

        startTimer();
        try {
          prova = await getProva();

          prova.downloadStatus = EnumDownloadStatus.BAIXANDO;

          if (onChangeStatusCallback != null) {
            onChangeStatusCallback!(prova.downloadStatus, getPorcentagem());
          }
          if (onTempoPrevistoChangeCallback != null) {
            onTempoPrevistoChangeCallback!(getTempoPrevisto());
          }

          switch (download.tipo) {
            case EnumDownloadTipo.QUESTAO:
              await retry(
                () async => await baixarQuestao(prova, download, apiService),
                retryIf: (e) => e is Exception,
                onRetry: (e) {
                  fine('[Prova $idProva] - Tentativa de download da Questão ID: ${download.id}');
                },
              );

              break;

            case EnumDownloadTipo.ALTERNATIVA:
              await retry(
                () async => await baixarAlternativa(download, apiService),
                retryIf: (e) => e is Exception,
                onRetry: (e) {
                  fine('[Prova $idProva] - Tentativa de download da Alternativa ID: ${download.id}');
                },
              );
              break;

            case EnumDownloadTipo.CONTEXTO_PROVA:
              await retry(
                () async => await contextoProva(download, apiService),
                retryIf: (e) => e is Exception,
                onRetry: (e) {
                  fine('[Prova $idProva] - Tentativa de download do Contexto ID: ${download.id}');
                },
              );
              break;

            case EnumDownloadTipo.VIDEO:
              await retry(
                () async => await baixarArquivoVideo(download, apiService),
                retryIf: (e) => e is Exception,
                onRetry: (e) {
                  fine('[Prova $idProva] - Tentativa de download do arquivo de Video ID: ${download.id}');
                },
              );

              break;

            case EnumDownloadTipo.AUDIO:
              await retry(
                () async => await baixarArquivoAudio(download, apiService),
                retryIf: (e) => e is Exception,
                onRetry: (e) {
                  fine('[Prova $idProva] - Tentativa de download do arquivo de Audio ID: ${download.id}');
                },
              );

              break;

            case EnumDownloadTipo.ARQUIVO:
              await retry(
                () async => await baixarArquivoImagem(download, apiService),
                retryIf: (e) => e is Exception,
                onRetry: (e) {
                  fine('[Prova $idProva] - Tentativa de download do arquivo de Imagemideo ID: ${download.id}');
                },
              );
              break;
          }
          downloadAtual = i;
          prova.downloadProgresso = getPorcentagem();

          await saveProva(prova);
          await saveDownloads();
        } catch (e, stack) {
          severe('[Prova $idProva] - ERRO: $e');
          severe(download);
          severe(stack);

          download.downloadStatus = EnumDownloadStatus.ERRO;
          prova.downloadStatus = EnumDownloadStatus.ERRO;

          if (onChangeStatusCallback != null) {
            onChangeStatusCallback!(prova.downloadStatus, getPorcentagem());
          }

          if (onTempoPrevistoChangeCallback != null) {
            onTempoPrevistoChangeCallback!(getTempoPrevisto());
          }
        }
      }
    }

    // Baixou todos os dados
    if (getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO).length == downloads.length) {
      try {
        prova.downloadStatus = EnumDownloadStatus.CONCLUIDO;

        //await validarProva();

        prova.questoes.sort(
          (questao1, questao2) {
            return questao1.ordem.compareTo(questao2.ordem);
          },
        );

        await deleteDownload();

        fine('[Prova $idProva] - Download Concluido');
        fine('[Prova $idProva] - Tempo total ${DateTime.now().difference(inicio).inSeconds}');
      } catch (e) {
        fine('[Prova $idProva] - Erro ao baixar prova');
        severe(e);
        prova.downloadStatus = EnumDownloadStatus.ERRO;
      } finally {
        if (onChangeStatusCallback != null) {
          onChangeStatusCallback!(prova.downloadStatus, getPorcentagem());
        }

        if (onTempoPrevistoChangeCallback != null) {
          onTempoPrevistoChangeCallback!(getTempoPrevisto());
        }

        try {
          int idDownload = await informarDownloadConcluido(prova.id);
          prova.idDownload = idDownload;
        } catch (e, stack) {
          severe('[Prova $idProva] - Erro ao informar download concluido');
          severe(e);
          severe(stack);
        }

        await saveProva(prova);
      }
    }

    cancelTimer();
  }

  salvarArquivoLocal(String url, String path) async {
    Uint8List contentes = await http.readBytes(Uri.parse(
      url.replaceFirst('http://', 'https://'),
    ));

    await saveFile(path, contentes);
  }

  Future<int> informarDownloadConcluido(int idProva) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    String modeloDispositivo;
    String dispositivoId = "";
    String versao = "";

    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      modeloDispositivo = webBrowserInfo.userAgent!;
      versao = webBrowserInfo.appVersion!;
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      modeloDispositivo = "${androidInfo.manufacturer!} ${androidInfo.model!}";
      dispositivoId = androidInfo.androidId!;
      versao = "Android ${androidInfo.version.release} (SDK ${androidInfo.version.release})";
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

  double getPorcentagem() {
    int baixado = downloads.where((element) => element.downloadStatus == EnumDownloadStatus.CONCLUIDO).length;

    return baixado / downloads.length;
  }

  double getTempoPrevisto() {
    return (downloads.length - downloadAtual) / (downloadAtual / (DateTime.now().difference(inicio).inSeconds));
  }

  saveDownloads() async {
    SharedPreferences prefs = GetIt.I.get();

    var downloadJson = jsonEncode(downloads);

    await prefs.setString('download_$idProva', downloadJson);
  }

  loadDownloads() async {
    SharedPreferences prefs = GetIt.I.get();

    var downloadJson = prefs.getString('download_$idProva');

    if (downloadJson != null) {
      downloads = (jsonDecode(downloadJson) as List<dynamic>)
          .map((e) => DownloadProva.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<Questao?> obterQuestaoPorArquivoLegadoId(int arquivoLegadoId, int provaId) async {
    AppDatabase db = GetIt.I.get();
    var questaoDb = await db.obterQuestaoPorArquivoLegadoId(arquivoLegadoId, provaId).getSingleOrNull();

    questaoDb ??= await db.obterQuestaoPorArquivoLegadoIdAlternativa(arquivoLegadoId, provaId).getSingleOrNull();

    if (questaoDb != null) {
      return Questao(
        id: questaoDb.id,
        titulo: questaoDb.titulo,
        tipo: EnumTipoQuestao.values.firstWhere((element) => element.index == questaoDb!.tipo),
        descricao: questaoDb.descricao,
        alternativas: [],
        arquivos: [],
        arquivosVideos: [],
        arquivosAudio: [],
        ordem: questaoDb.ordem,
        quantidadeAlternativas: questaoDb.quantidadeAlternativas!,
      );
    }
  }

  Future<Questao?> obterQuestaoPorArquivoLegadoIdAlternativa(int arquivoLegadoId, int provaId) async {
    AppDatabase db = GetIt.I.get();
    var questaoDb = await db.obterQuestaoPorArquivoLegadoIdAlternativa(arquivoLegadoId, provaId).getSingleOrNull();

    //questaoDb ??= await db.obterQuestaoAlternativaPorArquivoLegadoId(arquivoLegadoId, provaId).getSingleOrNull();

    if (questaoDb != null) {
      return Questao(
        id: questaoDb.id,
        titulo: questaoDb.titulo,
        tipo: EnumTipoQuestao.values.firstWhere((element) => element.index == questaoDb.tipo),
        descricao: questaoDb.descricao,
        alternativas: [],
        arquivos: [],
        arquivosVideos: [],
        arquivosAudio: [],
        ordem: questaoDb.ordem,
        quantidadeAlternativas: questaoDb.quantidadeAlternativas!,
      );
    }
  }

  bool containsId(int id, EnumDownloadTipo tipo) {
    return downloads.firstWhereOrNull((element) => element.id == id && element.tipo == tipo) != null;
  }

  List<DownloadProva> getDownlodsByStatus(EnumDownloadStatus status) {
    return downloads.where((element) => element.downloadStatus == status).toList();
  }

  Future<Prova> getProva() async {
    AppDatabase db = GetIt.I.get();

    var provaDb = await db.obterProvaPorId(idProva);

    Prova prova = Prova.fromProvaDb(provaDb);

    var questoesDb = await db.obterQuestoesPorProvaId(prova.id);
    prova.questoes = questoesDb
        .map(
          (e) => Questao(
            id: e.id,
            titulo: e.titulo,
            descricao: e.descricao,
            ordem: e.ordem,
            alternativas: [],
            arquivos: [],
            arquivosVideos: [],
            arquivosAudio: [],
            tipo: EnumTipoQuestao.values.firstWhere((element) => element.index == e.tipo),
            quantidadeAlternativas: e.quantidadeAlternativas!,
          ),
        )
        .toList();

    for (var questao in prova.questoes) {
      var alternativasDb = await db.obterAlternativasPorQuestaoId(questao.id);
      questao.alternativas = alternativasDb
          .map(
            (e) => Alternativa(
                numeracao: e.numeracao, descricao: e.descricao, id: e.id, ordem: e.ordem, questaoId: e.questaoId),
          )
          .toList();

      var arquivosDb = await db.obterArquivosPorQuestaoId(questao.id);
      questao.arquivos = arquivosDb
          .map(
            (e) => Arquivo(
              id: e.legadoId!,
              caminho: e.caminho,
              base64: e.base64,
              questaoId: e.questaoId,
            ),
          )
          .toList();

      var arquivosVideosDb = await db.arquivosVideosDao.obterPorQuestaoId(questao.id);
      questao.arquivosVideos = arquivosVideosDb
          .map(
            (e) => ArquivoVideo(
              id: e.id,
              path: e.path,
              idProva: e.provaId,
              idQuestao: e.questaoId,
            ),
          )
          .toList();

      var arquivosAudiosDb = await db.arquivosAudioDao.obterPorQuestaoId(questao.id);
      questao.arquivosAudio = arquivosAudiosDb
          .map(
            (e) => ArquivoAudio(
              id: e.id,
              path: e.path,
              idProva: e.provaId,
              idQuestao: e.questaoId,
            ),
          )
          .toList();

      var contextoDb = await db.obterContextoPorProvaId(prova.id);
      prova.contextosProva = contextoDb
          .map(
            (e) => ContextoProva(
              id: e.id,
              imagem: e.imagem,
              imagemBase64: e.imagemBase64,
              ordem: e.ordem,
              posicionamento: PosicionamentoImagemEnum.values[e.posicionamento!],
              provaId: e.provaId,
              texto: e.texto,
              titulo: e.titulo,
            ),
          )
          .toList();
    }

    return prova;
  }

  saveQuestao(Questao questao, int provaId) async {
    AppDatabase database = GetIt.I.get();

    await database.inserirOuAtualizarQuestao(
      QuestaoDb(
        id: questao.id,
        titulo: questao.titulo,
        descricao: questao.descricao,
        ordem: questao.ordem,
        tipo: questao.tipo.index,
        provaId: provaId,
        quantidadeAlternativas: questao.quantidadeAlternativas,
      ),
    );

    finer('[QUESTAO SALVA]');
  }

  saveAlternativa(Alternativa alternativa, int provaId) async {
    AppDatabase database = GetIt.I.get();

    await database.inserirOuAtualizarAlternativa(
      AlternativaDb(
          id: alternativa.id,
          descricao: alternativa.descricao,
          ordem: alternativa.ordem,
          numeracao: alternativa.numeracao,
          questaoId: alternativa.questaoId,
          provaId: provaId),
    );

    finer('[ALTERNATIVA SALVA]');
  }

  saveArquivo(Arquivo arquivo, int provaId) async {
    AppDatabase database = GetIt.I.get();

    await database.inserirOuAtualizarArquivo(
      ArquivoDb(
        id: int.parse("${arquivo.id}${arquivo.questaoId}"),
        legadoId: arquivo.id,
        caminho: arquivo.caminho,
        base64: arquivo.base64,
        questaoId: arquivo.questaoId,
        provaId: provaId,
      ),
    );

    finer('[ARQUIVO SALVO]');
  }

  saveContexto(ContextoProva contexto, int provaId) async {
    AppDatabase database = GetIt.I.get();

    await database.inserirOuAtualizarContextoProva(
      ContextoProvaDb(
        id: contexto.id!,
        ordem: contexto.ordem!,
        imagem: contexto.imagem,
        imagemBase64: contexto.imagemBase64,
        posicionamento: contexto.posicionamento!.index,
        texto: contexto.texto,
        titulo: contexto.titulo,
        provaId: provaId,
      ),
    );

    finer('[CONTEXTO SALVO]');
  }

  saveVideo(ArquivoVideo entity) async {
    AppDatabase database = GetIt.I.get();

    await database.arquivosVideosDao.inserirOuAtualizar(
      ArquivoVideoDb(
        id: entity.id,
        path: entity.path,
        questaoId: entity.idQuestao,
        provaId: entity.idProva,
      ),
    );

    finer('[VIDEO SALVO]');
  }

  saveAudio(ArquivoAudio entity) async {
    AppDatabase database = GetIt.I.get();

    await database.arquivosAudioDao.inserirOuAtualizar(
      ArquivoAudioDb(
        id: entity.id,
        path: entity.path,
        questaoId: entity.idQuestao,
        provaId: entity.idProva,
      ),
    );

    finer('[AUDIO SALVO]');
  }

  saveProva(Prova prova) async {
    AppDatabase db = GetIt.I.get();

    await db.inserirOuAtualizarProva(
      ProvaDb(
        id: prova.id,
        descricao: prova.descricao,
        downloadStatus: prova.downloadStatus.index,
        tempoExtra: prova.tempoExtra,
        tempoExecucao: prova.tempoExecucao,
        tempoAlerta: prova.tempoAlerta,
        itensQuantidade: prova.itensQuantidade,
        status: prova.status.index,
        dataInicio: prova.dataInicio,
        ultimaAtualizacao: DateTime.now(),
        dataFim: prova.dataFim,
        dataInicioProvaAluno: prova.dataInicioProvaAluno,
        dataFimProvaAluno: prova.dataFimProvaAluno,
        senha: prova.senha,
        idDownload: prova.idDownload,
      ),
    );

    var provaSalva = await db.obterProvaPorId(prova.id);
    finer('[ULTIMO SALVAMENTO] ${provaSalva.ultimaAtualizacao}');
  }

  deleteDownload() {
    SharedPreferences prefs = GetIt.I.get();
    prefs.remove('download_$idProva');
  }

  Future<void> _pause() async {
    try {
      for (var download in downloads) {
        if (download.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
          download.downloadStatus = EnumDownloadStatus.PAUSADO;
        }
      }
      var prova = await getProva();

      prova.downloadStatus = EnumDownloadStatus.PAUSADO;

      await saveProva(prova);

      await saveDownloads();
    } finally {
      _isPauseAllDownloads = false;
    }
  }

  validarProva() async {
    Prova prova = await getProva();

    for (var questao in prova.questoes) {
      switch (questao.tipo) {
        case EnumTipoQuestao.MULTIPLA_ESCOLHA:
          if (questao.alternativas.length != questao.quantidadeAlternativas) {
            throw ProvaDownloadException(
              prova.id,
              'Questão ${questao.id} deve conter ${questao.quantidadeAlternativas} alternatias, mas contem ${questao.alternativas.length} alternativas',
            );
          }

          break;

        case EnumTipoQuestao.RESPOSTA_CONTRUIDA:
          if (questao.alternativas.isNotEmpty) {
            throw ProvaDownloadException(
              prova.id,
              'Questão ${questao.id} não deve conter nenhuma alternativa',
            );
          }
          break;

        case EnumTipoQuestao.NAO_CADASTRADO:
          break;
      }
    }
  }

  baixarArquivoImagem(DownloadProva download, ApiService apiService) async {
    download.downloadStatus = EnumDownloadStatus.BAIXANDO;

    Response<ArquivoResponseDTO> response = await apiService.arquivo.getArquivo(idArquivo: download.id);

    if (response.isSuccessful) {
      Questao? questao = await obterQuestaoPorArquivoLegadoId(download.id, idProva);

      questao ??= await obterQuestaoPorArquivoLegadoIdAlternativa(download.id, idProva);

      ArquivoResponseDTO arquivo = response.body!;

      http.Response arquivoResponse = await http.get(
        Uri.parse(
          arquivo.caminho.replaceFirst('http://', 'https://'),
        ),
      );

      String base64 = base64Encode(arquivoResponse.bodyBytes);

      await saveArquivo(
          Arquivo(
            id: arquivo.id,
            caminho: arquivo.caminho,
            base64: base64,
            questaoId: questao!.id,
          ),
          idProva);

      download.downloadStatus = EnumDownloadStatus.CONCLUIDO;
    } else {
      download.downloadStatus = EnumDownloadStatus.ERRO;
    }
  }

  baixarArquivoVideo(DownloadProva download, ApiService apiService) async {
    download.downloadStatus = EnumDownloadStatus.BAIXANDO;

    // var response = ArquivoVideoResponseDTO(
    //   id: 1,
    //   caminho: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    //   caminhoVideoConvertido: 'video.mp4',
    //   caminhoVideoThumbinail: '-1',
    //   idQuestao: -1,
    // );
    Response<ArquivoVideoResponseDTO> response = await apiService.arquivo.getVideo(idArquivo: download.id);

    if (response.isSuccessful) {
      ArquivoVideoResponseDTO arquivo = response.body!;

      String path = join(
        'prova',
        idProva.toString(),
        'video',
        arquivo.questaoId.toString() + extension(arquivo.caminho),
      );

      await salvarArquivoLocal(arquivo.caminho, path);

      await saveVideo(
        ArquivoVideo(
          id: arquivo.id,
          path: path,
          idProva: idProva,
          idQuestao: arquivo.questaoId,
        ),
      );

      download.downloadStatus = EnumDownloadStatus.CONCLUIDO;
    } else {
      download.downloadStatus = EnumDownloadStatus.ERRO;
    }
  }

  baixarArquivoAudio(DownloadProva download, ApiService apiService) async {
    download.downloadStatus = EnumDownloadStatus.BAIXANDO;

    Response<ArquivoResponseDTO> response = await apiService.arquivo.getAudio(idArquivo: download.id);

    if (response.isSuccessful) {
      ArquivoResponseDTO arquivo = response.body!;

      String path = join(
        'prova',
        idProva.toString(),
        'audio',
        arquivo.questaoId.toString() + extension(arquivo.caminho),
      );

      await salvarArquivoLocal(arquivo.caminho, path);

      await saveAudio(
        ArquivoAudio(
          id: arquivo.id,
          path: path,
          idProva: idProva,
          idQuestao: arquivo.questaoId,
        ),
      );

      download.downloadStatus = EnumDownloadStatus.CONCLUIDO;
    } else {
      download.downloadStatus = EnumDownloadStatus.ERRO;
    }
  }

  contextoProva(DownloadProva download, ApiService apiService) async {
    download.downloadStatus = EnumDownloadStatus.BAIXANDO;

    Response<ContextoProvaResponseDTO> response = await apiService.contextoProva.getContextoProva(id: download.id);

    if (response.isSuccessful) {
      ContextoProvaResponseDTO contexto = response.body!;

      http.Response contextoResponse = await http.get(
        Uri.parse(
          contexto.imagem!.replaceFirst('http://', 'https://'),
        ),
      );

      String base64 = base64Encode(contextoResponse.bodyBytes);

      await saveContexto(
        ContextoProva(
          id: contexto.id,
          imagem: contexto.imagem,
          imagemBase64: base64,
          ordem: contexto.ordem,
          posicionamento: contexto.posicionamento,
          provaId: contexto.provaId,
          texto: contexto.texto,
          titulo: contexto.titulo,
        ),
        idProva,
      );

      download.downloadStatus = EnumDownloadStatus.CONCLUIDO;
    }
  }

  baixarAlternativa(DownloadProva download, ApiService apiService) async {
    download.downloadStatus = EnumDownloadStatus.BAIXANDO;

    Response<AlternativaResponseDTO> response = await apiService.alternativa.getAlternativa(idAlternativa: download.id);

    if (response.isSuccessful) {
      AlternativaResponseDTO alternativaDTO = response.body!;

      Alternativa alternativa = Alternativa(
        id: alternativaDTO.id,
        descricao: alternativaDTO.descricao,
        ordem: alternativaDTO.ordem,
        numeracao: alternativaDTO.numeracao,
        questaoId: alternativaDTO.questaoId,
      );

      await saveAlternativa(alternativa, idProva);

      download.downloadStatus = EnumDownloadStatus.CONCLUIDO;
    }
  }

  baixarQuestao(Prova prova, DownloadProva download, ApiService apiService) async {
    download.downloadStatus = EnumDownloadStatus.BAIXANDO;

    Questao? questao = prova.questoes.firstWhereOrNull((element) => element.id == download.id);

    if (questao == null) {
      Response<QuestaoResponseDTO> response = await apiService.questao.getQuestao(idQuestao: download.id);

      if (response.isSuccessful) {
        QuestaoResponseDTO questaoDTO = response.body!;

        Questao questao = Questao(
          id: questaoDTO.id,
          titulo: questaoDTO.titulo,
          descricao: questaoDTO.descricao,
          ordem: questaoDTO.ordem,
          alternativas: [],
          arquivos: [],
          arquivosVideos: [],
          arquivosAudio: [],
          tipo: questaoDTO.tipo,
          quantidadeAlternativas: questaoDTO.quantidadeAlternativas,
        );

        await saveQuestao(questao, idProva);
      }
    }
    download.downloadStatus = EnumDownloadStatus.CONCLUIDO;
  }
}
