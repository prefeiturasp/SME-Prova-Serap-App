import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobx/mobx.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/download.service.dart';

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
  EnumDownloadStatus status = EnumDownloadStatus.NAO_INICIADO;

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
    await downloadService.configure();

    print('** Total Downloads ${downloadService.downloads.length}');
    print('** Downloads concluidos ${downloadService.getDownlodsByStatus(EnumDownloadStatus.CONCLUIDO).length}');
    print('** Downloads nao Iniciados ${downloadService.getDownlodsByStatus(EnumDownloadStatus.NAO_INICIADO).length}');

    downloadService.onStatusChange((status, progressoDownload) {
      this.status = status;
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
      reaction((_) => status, onStatusChange),
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
      if (status != EnumDownloadStatus.CONCLUIDO) {
        iniciarDownload();
      }
    } else {
      status = EnumDownloadStatus.PAUSADO;
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
}
