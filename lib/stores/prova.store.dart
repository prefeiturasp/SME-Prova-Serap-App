import 'dart:convert';
import 'dart:developer';

import 'package:appserap/dependencias.ioc.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova_resposta.store.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/workers/sincronizar_resposta.worker.dart';
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

  _ProvaStoreBase({
    required this.id,
    required this.prova,
    required this.respostas,
  }) {
    downloadService = DownloadService(idProva: id);
  }

  @observable
  ProvaRespostaStore respostas;

  @observable
  EnumDownloadStatus downloadStatus = EnumDownloadStatus.NAO_INICIADO;

  @observable
  EnumProvaStatus status = EnumProvaStatus.NAO_INICIADA;

  @observable
  double tempoPrevisto = 0;

  @observable
  double progressoDownload = 0;

  @observable
  String icone = AssetsUtil.iconeProva;

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
        icone = AssetsUtil.iconeProva;
        break;
      case EnumDownloadStatus.BAIXANDO:
        icone = AssetsUtil.iconeProvaDownload;
        break;
      case EnumDownloadStatus.ERRO:
      case EnumDownloadStatus.PAUSADO:
        icone = AssetsUtil.iconeProvaErroDownload;
        break;
    }
  }

  @action
  iniciarProva() async {
    setStatusProva(EnumProvaStatus.INICIADA);

    await GetIt.I.get<ApiService>().prova.setStatusProva(idProva: id, status: EnumProvaStatus.INICIADA.index);

    await saveProva();
  }

  @action
  setStatusProva(EnumProvaStatus provaStatus) {
    prova.status = provaStatus;
    status = provaStatus;
  }

  saveProva() async {
    SharedPreferences prefs = GetIt.I.get();

    await prefs.setString('prova_${prova.id}', jsonEncode(prova.toJson()));
  }

  @action
  Future<bool> finalizarProva() async {
    try {
      ConnectivityResult resultado = await (Connectivity().checkConnectivity());

      if (resultado == ConnectivityResult.none) {
        // Se estiver sem internet alterar status para pendente (worker ira sincronizar)

        setStatusProva(EnumProvaStatus.PENDENTE);
        await saveProva();

        var retorno = await mostrarDialogSemInternet();
        return retorno ?? false;
      } else {
        // Atualiza para finalizada
        setStatusProva(EnumProvaStatus.FINALIZADA);
        await saveProva();

        await SincronizarRespostasWorker().sincronizar();

        // Sincroniza com a api
        var response = await GetIt.I.get<ApiService>().prova.setStatusProva(
              idProva: id,
              status: EnumProvaStatus.FINALIZADA.index,
            );

        if (response.isSuccessful) {
          mostrarDialogProvaEnviada();
        } else {
          switch (response.statusCode) {
            case 411:
              // Remove prova do cache
              SharedPreferences prefs = ServiceLocator.get();
              await prefs.remove('prova_${prova.id}');

              // Remove respostas da prova do cache
              for (var questoes in prova.questoes) {
                await prefs.remove('resposta_${questoes.id}');
              }

              mostrarDialogProvaJaEnviada();
              break;
          }
        }
      }

      return true;
    } catch (e) {
      severe(e);
      return false;
    }
  }
}
