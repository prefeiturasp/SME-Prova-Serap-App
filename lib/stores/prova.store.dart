import 'dart:convert';

import 'package:appserap/utils/date.util.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/managers/download.manager.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova_resposta.store.dart';
import 'package:appserap/stores/prova_tempo_exeucao.store.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/workers/sincronizar_resposta.worker.dart';

part 'prova.store.g.dart';

class ProvaStore = _ProvaStoreBase with _$ProvaStore;

abstract class _ProvaStoreBase with Store, Loggable, Disposable {
  List<ReactionDisposer> _reactions = [];

  @observable
  ObservableStream<ConnectivityStatus> conexaoStream = ObservableStream(Connectivity().onConnectivityChanged);

  late GerenciadorDownload gerenciadorDownload;

  int id;

  @observable
  Prova prova;

  _ProvaStoreBase({
    required this.id,
    required this.prova,
    required this.respostas,
  }) {
    gerenciadorDownload = GerenciadorDownload(idProva: id);
    status = prova.status;
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

  @observable
  ProvaTempoExecucaoStore? tempoExecucaoStore;

  @action
  iniciarDownload() async {
    info('Iniciando Download');
    downloadStatus = EnumDownloadStatus.BAIXANDO;

    await gerenciadorDownload.configure();

    gerenciadorDownload.onStatusChange((downloadStatus, progressoDownload) {
      this.downloadStatus = downloadStatus;
      this.progressoDownload = progressoDownload;
    });

    gerenciadorDownload.onTempoPrevistoChange((tempoPrevisto) {
      this.tempoPrevisto = tempoPrevisto;
    });

    await gerenciadorDownload.startDownload();

    prova = await gerenciadorDownload.getProva();
  }

  @action
  configure() {
    _setupReactions();
    _configurarTempoExecucao();
  }

  _setupReactions() {
    _reactions = [
      reaction((_) => downloadStatus, onStatusChange),
      reaction((_) => conexaoStream.value, onChangeConexao),
    ];
  }

  @action
  Future onChangeConexao(ConnectivityStatus? resultado) async {
    if (downloadStatus == EnumDownloadStatus.CONCLUIDO) {
      return;
    }

    if (resultado != ConnectivityStatus.none) {
      await iniciarDownload();
    } else {
      downloadStatus = EnumDownloadStatus.PAUSADO;
      gerenciadorDownload.pause();
    }
  }

  @action
  onStatusChange(EnumDownloadStatus statusDownload) {
    switch (statusDownload) {
      case EnumDownloadStatus.BAIXANDO:
        icone = AssetsUtil.iconeProvaDownload;
        break;
      case EnumDownloadStatus.ERRO:
      case EnumDownloadStatus.PAUSADO:
        icone = AssetsUtil.iconeProvaErroDownload;
        break;

      case EnumDownloadStatus.NAO_INICIADO:
      case EnumDownloadStatus.CONCLUIDO:
      default:
        icone = AssetsUtil.iconeProva;
        break;
    }
  }

  @action
  iniciarProva() async {
    setStatusProva(EnumProvaStatus.INICIADA);
    prova.dataInicioProvaAluno = DateTime.now();

    try {
      await GetIt.I.get<ApiService>().prova.setStatusProva(idProva: id, status: EnumProvaStatus.INICIADA.index);
    } catch (e) {
      warning(e);
    }

    await saveProva();
    iniciarTemporizador();
  }

  @action
  continuarProva() async {
    iniciarTemporizador();
  }

  iniciarTemporizador() {
    if (prova.tempoExecucao > 0) {
      tempoExecucaoStore!.iniciarContador(prova.dataInicioProvaAluno!);
    }
  }

  /// Configura o tempo de execução da prova
  @action
  _configurarTempoExecucao() {
    if (prova.tempoExecucao > 0) {
      fine('Configurando controlador de tempo');

      tempoExecucaoStore = ProvaTempoExecucaoStore(
        duracaoProva: Duration(seconds: prova.tempoExecucao ~/ 10),
        duracaoTempoExtra: Duration(seconds: prova.tempoExtra ~/ 10),
        duracaoTempoFinalizando: Duration(minutes: 5),
      );
    }
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
  Future<bool> finalizarProva(BuildContext context, [bool automaticamente = false]) async {
    try {
      ConnectivityStatus resultado = await (Connectivity().checkConnectivity());
      prova.dataFimProvaAluno = DateTime.now();

      if (resultado == ConnectivityStatus.none) {
        warning('Prova finalizada sem internet. Sincronização Pendente.');
        // Se estiver sem internet alterar status para pendente (worker ira sincronizar)

        setStatusProva(EnumProvaStatus.PENDENTE);
        await saveProva();

        var retorno = await mostrarDialogSemInternet(context);
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
              dataFim: getTicks(prova.dataFimProvaAluno!),
            );

        if (response.isSuccessful) {
          var retorno;

          if (automaticamente) {
            retorno = await mostrarDialogProvaFinalizadaAutomaticamente(context);
          } else {
            retorno = await mostrarDialogProvaEnviada(context);
          }

          return retorno ?? false;
        } else {
          switch (response.statusCode) {
            // Prova ja finalizada
            case 411:
              // Remove prova do cache
              SharedPreferences prefs = ServiceLocator.get();
              await prefs.remove('prova_${prova.id}');

              // Remove respostas da prova do cache
              for (var questoes in prova.questoes) {
                await prefs.remove('resposta_${questoes.id}');
              }

              mostrarDialogProvaJaEnviada(context);
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

  @override
  onDispose() {
    for (var _reaction in _reactions) {
      _reaction();
    }
    tempoExecucaoStore?.onDispose();
  }
}
