import 'dart:async';
import 'dart:convert';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/contexto_prova.response.dto.dart';
import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/exceptions/prova_download.exception.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:asuka/snackbars/asuka_snack_bar.dart';
import 'package:chopper/src/response.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes.response.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/exceptions/prova_download.exception.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/download_prova.model.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/services/api.dart';
import 'package:asuka/snackbars/asuka_snack_bar.dart';
import 'package:chopper/src/response.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

typedef StatusChangeCallback = void Function(EnumDownloadStatus downloadStatus, double porcentagem);
typedef TempoPrevistoChangeCallback = void Function(double tempoPrevisto);

class GerenciadorDownload with Loggable {
  int idProva;
  List<DownloadProva> downloads = [];
  late DateTime inicio;
  late int downloadAtual;

  StatusChangeCallback? onChangeStatusCallback;
  TempoPrevistoChangeCallback? onTempoPrevistoChangeCallback;

  Timer? timer;

  GerenciadorDownload({
    required this.idProva,
  });

  Future<void> configure() async {
    ApiService apiService = GetIt.I.get();

    try {
      Response<ProvaDetalhesResponseDTO> response = await apiService.prova.getResumoProva(idProva: idProva);

      if (!response.isSuccessful) {
        return;
      }

      var provaDetalhes = response.body!;

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

      finer('** Total Downloads ${downloads.length}');
      finer('** Downloads concluidos ${getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO).length}');
      finer('** Downloads nao Iniciados ${getDownlodsByStatus(EnumDownloadStatus.NAO_INICIADO).length}');

      await saveDownloads();
    } catch (e) {
      AsukaSnackbar.alert("Não foi possível obter os detalhes da prova").show();
      return;
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

    downloads.sort((a, b) => a.tipo.index.compareTo(b.tipo.index));

    for (var i = 0; i < downloads.length; i++) {
      var download = downloads[i];

      if (download.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
        finer('[Prova $idProva] - Iniciando download TIPO: ${download.tipo} ID: ${download.id}');

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
                    tipo: questaoDTO.tipo,
                  );

                  await saveQuestao(questao, idProva);
                }
              }
              download.downloadStatus = EnumDownloadStatus.CONCLUIDO;
              break;

            case EnumDownloadTipo.ALTERNATIVA:
              download.downloadStatus = EnumDownloadStatus.BAIXANDO;

              Response<AlternativaResponseDTO> response =
                  await apiService.alternativa.getAlternativa(idAlternativa: download.id);

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
              break;

            case EnumDownloadTipo.ARQUIVO:
              download.downloadStatus = EnumDownloadStatus.BAIXANDO;

              Questao? questao = await obterQuestaoPorArquivoLegadoId(download.id, idProva);

              Response<ArquivoResponseDTO> response = await apiService.arquivo.getArquivo(idArquivo: download.id);

              if (response.isSuccessful) {
                ArquivoResponseDTO arquivo = response.body!;

                http.Response arquivoResponse = await http.get(
                  Uri.parse(
                    arquivo.caminho.replaceFirst('http://', 'https://'),
                  ),
                );

                // ByteData imageData = await NetworkAssetBundle(Uri.parse(arquivo.caminho)).load("");
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
              }
              break;

            case EnumDownloadTipo.CONTEXTO_PROVA:
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
                      titulo: contexto.titulo),
                  idProva,
                );

                download.downloadStatus = EnumDownloadStatus.CONCLUIDO;
              }
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

        await saveProva(prova);
      }
    }

    cancelTimer();
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

    if (questaoDb != null) {
      return Questao(
          id: questaoDb.id,
          titulo: questaoDb.titulo,
          tipo: EnumTipoQuestao.values.firstWhere((element) => element.index == questaoDb.tipo),
          descricao: questaoDb.descricao,
          alternativas: [],
          arquivos: [],
          ordem: questaoDb.ordem);
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
            tipo: EnumTipoQuestao.values.firstWhere((element) => element.index == e.tipo),
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
              id: e.id,
              caminho: e.caminho,
              base64: e.base64,
              questaoId: e.questaoId,
            ),
          )
          .toList();

      var contextoDb = await db.obterContextoPorProvaId(prova.id);
      prova.contextosProva = contextoDb.map(
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
      ).toList();
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
          provaId: provaId),
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
        id: arquivo.id,
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

    fine('[CONTEXTO SALVO]');
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
      ),
    );

    var provaSalva = await db.obterProvaPorId(prova.id);
    finer('[ULTIMO SALVAMENTO] ${provaSalva.ultimaAtualizacao}');
  }

  deleteDownload() {
    SharedPreferences prefs = GetIt.I.get();
    prefs.remove('download_$idProva');
  }

  Future<void> pause() async {
    for (var download in downloads) {
      if (download.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
        download.downloadStatus = EnumDownloadStatus.PAUSADO;
      }
    }
    var prova = await getProva();

    prova.downloadStatus = EnumDownloadStatus.PAUSADO;

    await saveProva(prova);

    await saveDownloads();
  }

  validarProva() async {
    Prova prova = await getProva();

    for (var questao in prova.questoes) {
      switch (questao.tipo) {
        case EnumTipoQuestao.MULTIPLA_ESCOLHA_4:
          if (questao.alternativas.length != 4) {
            throw ProvaDownloadException(
              prova.id,
              'Questão ${questao.id} deve conter 4 alternatias, mas contem ${questao.alternativas.length} alternativas',
            );
          }

          break;
        case EnumTipoQuestao.MULTIPLA_ESCOLHA_5:
          if (questao.alternativas.length != 5) {
            throw ProvaDownloadException(
              prova.id,
              'Questão ${questao.id} deve conter 5 alternatias, mas contem ${questao.alternativas.length} alternativas',
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

        default:
          break;
      }
    }
  }
}
