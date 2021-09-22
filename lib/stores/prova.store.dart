import 'dart:convert';

import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/download.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prova.store.g.dart';

class ProvaStore = _ProvaStoreBase with _$ProvaStore;

abstract class _ProvaStoreBase with Store, Loggable {
  List<ReactionDisposer> _reactions = [];

  @observable
  ObservableStream<ConnectivityResult> conexaoStream = ObservableStream(Connectivity().onConnectivityChanged);

  late DownloadService downloadService;

  int id;

  @observable
  Prova prova;

  @observable
  EnumDownloadStatus downloadStatus = EnumDownloadStatus.NAO_INICIADO;

  @observable
  EnumProvaStatus status = EnumProvaStatus.NAO_INICIADA;

  @observable
  double tempoPrevisto = 0;

  @observable
  double progressoDownload = 0;

  @observable
  String icone = "assets/images/prova.svg";

  _ProvaStoreBase({
    required this.id,
    required this.prova,
  }) {
    downloadService = DownloadService(idProva: id);
  }

  @action
  iniciarDownload() async {
    downloadStatus = EnumDownloadStatus.BAIXANDO;

    await downloadService.configure();

    fine('** Total Downloads ${downloadService.downloads.length}');
    fine('** Downloads concluidos ${downloadService.getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO).length}');
    fine('** Downloads nao Iniciados ${downloadService.getDownlodsByStatus(EnumDownloadStatus.NAO_INICIADO).length}');

    downloadService.onStatusChange((downloadStatus, progressoDownload) {
      this.downloadStatus = downloadStatus;
      this.progressoDownload = progressoDownload;
    });

    downloadService.onTempoPrevistoChange((tempoPrevisto) {
      this.tempoPrevisto = tempoPrevisto;
    });

    await downloadService.startDownload();

    prova = await downloadService.getProva();
  }

  setupReactions() {
    _reactions = [
      reaction((_) => downloadStatus, onStatusChange),
      reaction((_) => conexaoStream.value, onChangeConexao),
    ];
  }

  dispose() {
    for (var _reaction in _reactions) {
      _reaction();
    }
  }

  @action
  Future onChangeConexao(ConnectivityResult? resultado) async {
    if (downloadStatus == EnumDownloadStatus.CONCLUIDO) {
      return;
    }

    if (resultado != ConnectivityResult.none) {
      iniciarDownload();
    } else {
      downloadStatus = EnumDownloadStatus.PAUSADO;
      downloadService.pause();
    }
  }

  @action
  onStatusChange(EnumDownloadStatus statusDownload) {
    switch (statusDownload) {
      case EnumDownloadStatus.NAO_INICIADO:
      case EnumDownloadStatus.CONCLUIDO:
        icone = "assets/images/prova.svg";
        break;
      case EnumDownloadStatus.BAIXANDO:
        icone = "assets/images/prova_download.svg";
        break;
      case EnumDownloadStatus.ERRO:
      case EnumDownloadStatus.PAUSADO:
        icone = "assets/images/prova_erro_download.svg";
        break;
    }
  }

  @action
  iniciarProva() async {
    prova.status = EnumProvaStatus.INICIADA;
    status = EnumProvaStatus.INICIADA;

    await GetIt.I.get<ApiService>().prova.setStatusProva(idProva: id, status: EnumProvaStatus.INICIADA.index);

    await saveProva();
  }

  saveProva() async {
    SharedPreferences pref = GetIt.I.get();

    await pref.setString('prova_${prova.id}', jsonEncode(prova.toJson()));
  }
}
