import 'dart:async';
import 'dart:convert';

import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/exceptions/prova_download.exception.dart';
import 'package:asuka/snackbars/asuka_snack_bar.dart';
import 'package:chopper/src/response.dart';
import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes.response.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/download_prova.model.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/services/api.dart';

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
        if (!containsId(idQuestao)) {
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
        if (!containsId(idArquivo)) {
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
        if (!containsId(idAlternativa)) {
          downloads.add(
            DownloadProva(
              tipo: EnumDownloadTipo.ALTERNATIVA,
              id: idAlternativa,
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
                  QuestaoResponseDTO questao = response.body!;

                  prova.questoes.add(Questao(
                    id: questao.id,
                    titulo: questao.titulo,
                    descricao: questao.descricao,
                    ordem: questao.ordem,
                    alternativas: [],
                    arquivos: [],
                    tipo: questao.tipo,
                  ));
                }
              }

              break;
            case EnumDownloadTipo.ALTERNATIVA:
              download.downloadStatus = EnumDownloadStatus.BAIXANDO;

              Response<AlternativaResponseDTO> response =
                  await apiService.alternativa.getAlternativa(idAlternativa: download.id);

              if (response.isSuccessful) {
                AlternativaResponseDTO alternativa = response.body!;

                Questao? questao = prova.questoes.firstWhereOrNull((element) => element.id == alternativa.questaoId);

                if (questao != null) {
                  questao.alternativas.add(Alternativa(
                    id: alternativa.id,
                    descricao: alternativa.descricao,
                    ordem: alternativa.ordem,
                    numeracao: alternativa.numeracao,
                    questaoId: alternativa.questaoId,
                  ));

                  download.downloadStatus = EnumDownloadStatus.CONCLUIDO;
                } else {
                  warning('Alternativa ${download.id} nao vinculado a nenhuma questão!');
                }
              }

              break;
            case EnumDownloadTipo.ARQUIVO:
              download.downloadStatus = EnumDownloadStatus.BAIXANDO;

              Questao? questao = prova.questoes.firstWhereOrNull((element) =>
                  element.titulo.contains(download.id.toString()) ||
                  element.descricao.contains(download.id.toString()));

              if (questao != null) {
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

                  questao.arquivos.add(Arquivo(
                    id: arquivo.id,
                    caminho: arquivo.caminho,
                    base64: base64,
                  ));
                } else {
                  warning('Arquivo ${download.id} nao vinculado a nenhuma questao');
                }
              }

              break;
          }

          download.downloadStatus = EnumDownloadStatus.CONCLUIDO;

          downloadAtual = i;
          prova.downloadProgresso = getPorcentagem();

          await saveProva(prova);
          await saveDownloads();
        } catch (e, stack) {
          severe('[Prova $idProva] ERRO: $e');
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

        await validarProva();

        prova.questoes.sort(
          (questao1, questao2) {
            return questao1.ordem.compareTo(questao2.ordem);
          },
        );

        await deleteDownload();

        fine('[Prova $idProva] Download Concluido');
        fine('[Prova $idProva] Tempo total ${DateTime.now().difference(inicio).inSeconds}');
      } catch (e) {
        fine('[Prova $idProva] Erro ao baixar prova');
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

  bool containsId(int id) {
    return downloads.firstWhereOrNull((element) => element.id == id) != null;
  }

  List<DownloadProva> getDownlodsByStatus(EnumDownloadStatus status) {
    return downloads.where((element) => element.downloadStatus == status).toList();
  }

  Future<Prova> getProva() async {
    SharedPreferences prefs = GetIt.I.get();

    var provaJson = prefs.getString('prova_$idProva');

    return Prova.fromJson(jsonDecode(provaJson!));
  }

  saveProva(Prova prova) async {
    SharedPreferences prefs = GetIt.I.get();

    await prefs.setString('prova_${prova.id}', jsonEncode(prova.toJson()));
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
