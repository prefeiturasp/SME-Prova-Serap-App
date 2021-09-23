import 'dart:convert';

import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/utils/icone.util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/download.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prova.store.g.dart';

class ProvaStore = _ProvaStoreBase with _$ProvaStore;

abstract class _ProvaStoreBase with Store {
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
  String icone = IconeUtil.iconeProva;

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

    print('** Total Downloads ${downloadService.downloads.length}');
    print('** Downloads concluidos ${downloadService.getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO).length}');
    print('** Downloads nao Iniciados ${downloadService.getDownlodsByStatus(EnumDownloadStatus.NAO_INICIADO).length}');

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
    if (resultado != ConnectivityResult.none) {
      if (downloadStatus == EnumDownloadStatus.CONCLUIDO) {
        return;
      }

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
        icone = IconeUtil.iconeProva;
        break;
      case EnumDownloadStatus.BAIXANDO:
        icone = IconeUtil.iconeProvaDownload;
        break;
      case EnumDownloadStatus.ERRO:
      case EnumDownloadStatus.PAUSADO:
        icone = IconeUtil.iconeProvaErroDownload;
        break;
    }
  }

  @action
  iniciarProva() {
    prova.status = EnumProvaStatus.INICIADA;
    status = EnumProvaStatus.INICIADA;
    saveProva();
  }

  saveProva() async {
    SharedPreferences pref = GetIt.I.get();

    await pref.setString('prova_${prova.id}', jsonEncode(prova.toJson()));
  }
}
