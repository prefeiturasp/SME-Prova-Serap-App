import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:chopper/src/response.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'package:appserap/dtos/prova_detalhes.response.dto.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:appserap/models/download_prova.model.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class Loggable<T> {
  var log = Logger(T.toString());
  var info = Logger(T.toString()).info;
  var warning = Logger(T.toString()).warning;
  var severe = Logger(T.toString()).severe;
}

typedef StatusChangeCallback = void Function(EnumDownloadStatus downloadStatus, double porcentagem);

class DownloadService with Loggable {
  int idProva;
  List<DownloadProva> downloads = [];
  late DateTime inicio;
  late int downloadAtual;

  late StatusChangeCallback onChangeStatusCallback;
  late void Function(double tempoPrevisto) onTempoPrevistoChangeCallback;

  Timer? timer;

  DownloadService({
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

      info('Total de Downloads ${downloads.length}');
      // TODO salvar download
      await saveDownloads();
    } catch (e) {
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
      onTempoPrevistoChangeCallback(getTempoPrevisto());
    });
  }

  cancelTimer() {
    timer?.cancel();
  }

  Future<void> startDownload() async {
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

          onChangeStatusCallback(prova.downloadStatus, getPorcentagem());
          onTempoPrevistoChangeCallback(getTempoPrevisto());

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

                  ByteData imageData = await NetworkAssetBundle(Uri.parse(arquivo.caminho)).load("");
                  String base64 = base64Encode(imageData.buffer.asUint8List());

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
            case EnumDownloadTipo.RESPOSTA:
              // TODO: Handle this case.

              break;
          }

          download.downloadStatus = EnumDownloadStatus.CONCLUIDO;

          downloadAtual = i;
          prova.downloadProgresso = getPorcentagem();

          await saveProva(prova);
          await saveDownloads();
        } catch (e, stak) {
          severe('ERRO: ', e, stak);
          download.downloadStatus = EnumDownloadStatus.ERRO;
          prova.downloadStatus = EnumDownloadStatus.ERRO;
          onChangeStatusCallback(prova.downloadStatus, getPorcentagem());
          onTempoPrevistoChangeCallback(getTempoPrevisto());
        }
      }
    }

    // Baixou todos os dados
    if (getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO).length == downloads.length) {
      prova.downloadStatus = EnumDownloadStatus.CONCLUIDO;

      onChangeStatusCallback(prova.downloadStatus, getPorcentagem());
      onTempoPrevistoChangeCallback(getTempoPrevisto());

      await saveProva(prova);
      await deleteDownload();

      print('Download Concluido');
      print('Tempo total ${DateTime.now().difference(inicio).inSeconds}');
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
    SharedPreferences pref = await GetIt.I.getAsync();

    var downloadJson = jsonEncode(downloads);

    await pref.setString('download_$idProva', downloadJson);

    warning('Salvando downloads');
  }

  loadDownloads() async {
    SharedPreferences pref = await GetIt.I.getAsync();

    var downloadJson = pref.getString('download_$idProva');

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
    SharedPreferences pref = GetIt.I.get();

    var provaJson = pref.getString('prova_$idProva');

    return Prova.fromJson(jsonDecode(provaJson!));
  }

  saveProva(Prova prova) async {
    SharedPreferences pref = GetIt.I.get();

    await pref.setString('prova_${prova.id}', jsonEncode(prova.toJson()));
  }

  deleteDownload() {
    SharedPreferences pref = GetIt.I.get();
    pref.remove('download_$idProva');
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
}
