import 'dart:async';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/managers/download.manager.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/enums/tempo_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova_resposta.store.dart';
import 'package:appserap/stores/prova_tempo_exeucao.store.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/date.util.dart';

part 'prova.store.g.dart';

class ProvaStore extends _ProvaStoreBase with _$ProvaStore {
  ProvaStore({
    required int id,
    required Prova prova,
    required ProvaRespostaStore respostas,
  }) : super(id: id, prova: prova, respostas: respostas) {
    downloadManagerStore = DownloadManagerStore(provaStore: this);
  }
}

abstract class _ProvaStoreBase with Store, Loggable, Disposable {
  var _usuarioStore = ServiceLocator.get<UsuarioStore>();
  List<ReactionDisposer> _reactions = [];

  @observable
  ObservableStream<ConnectivityStatus> conexaoStream = ObservableStream(Connectivity().onConnectivityChanged);

  // late GerenciadorDownload gerenciadorDownload;

  late DownloadManagerStore downloadManagerStore;

  int id;

  @observable
  Prova prova;

  @observable
  bool isVisible = true;

  _ProvaStoreBase({
    required this.id,
    required this.prova,
    required this.respostas,
  }) {
    status = prova.status;
  }

  @observable
  ProvaRespostaStore respostas;

  @observable
  EnumDownloadStatus downloadStatus = EnumDownloadStatus.NAO_INICIADO;

  @observable
  EnumTempoStatus tempoCorrendo = EnumTempoStatus.PARADO;

  @observable
  EnumProvaStatus status = EnumProvaStatus.NAO_INICIADA;

  @observable
  double tempoPrevisto = 0;

  @observable
  double progressoDownload = 0;

  @observable
  String icone = AssetsUtil.iconeProva;

  @observable
  String codigoIniciarProva = "";

  @observable
  ProvaTempoExecucaoStore? tempoExecucaoStore;
  int segundos = 0;

  @observable
  DateTime inicioQuestao = DateTime.now();

  @observable
  DateTime fimQuestao = DateTime.now();

  @action
  setRespondendoProva(bool value) {
    _usuarioStore.isRespondendoProva = value;
  }

  @action
  iniciarDownload() async {
    downloadStatus = EnumDownloadStatus.BAIXANDO;

    fine("[Prova $id] - Configurando Download");

    downloadManagerStore.listen((downloadStatus, progressoDownload, tempoPrevisto) {
      this.downloadStatus = downloadStatus;
      this.progressoDownload = progressoDownload;
      this.tempoPrevisto = tempoPrevisto;
    });

    downloadManagerStore.onTempoPrevistoChange((tempoPrevisto) {
      this.tempoPrevisto = tempoPrevisto;
    });

    await downloadManagerStore.iniciarDownload();

    await respostas.carregarRespostasServidor(prova);

    var obterProva = await Prova.carregaProvaCache(id);

    prova = obterProva!;

    fine("[Prova $id] - Download Concluído");
  }

  @action
  configure() {
    _setupReactions();
    _configurarTempoExecucao();
  }

  _setupReactions() {
    _reactions = [
      reaction((_) => downloadStatus, onStatusChange),
      reaction(
        (_) => conexaoStream.value,
        onChangeConexao,
        fireImmediately: false,
      ),
      reaction((_) => tempoCorrendo, onChangeContadorQuestao),
      reaction((_) => _usuarioStore.isRespondendoProva, _onRespondendoProvaChange),
    ];
  }

  @action
  onChangeContadorQuestao(EnumTempoStatus finalizado) {
    if (finalizado == EnumTempoStatus.CORRENDO) {
      inicioQuestao = DateTime.now();
      fine(' Inicio da Questão: $inicioQuestao');
    } else if (finalizado == EnumTempoStatus.CONTINUAR) {
      return;
    } else {
      DateTime fimQuestao = DateTime.now();

      segundos = fimQuestao.difference(inicioQuestao).inSeconds;

      fine(' Fim da Questão: $fimQuestao');

      fine(' Segundos: $segundos');
    }
  }

  @action
  _onRespondendoProvaChange(bool isRepondendoProva) async {
    if (downloadStatus == EnumDownloadStatus.CONCLUIDO) {
      return;
    }

    if (isRepondendoProva && downloadStatus == EnumDownloadStatus.BAIXANDO) {
      info("[Prova $id] - Download Pausado");
      downloadStatus = EnumDownloadStatus.PAUSADO;
      downloadManagerStore.pauseAllDownloads();
    }
    if (!isRepondendoProva && downloadStatus == EnumDownloadStatus.PAUSADO) {
      info("[Prova $id] - Download Resumido");

      await iniciarDownload();
    }
  }

  @action
  Future onChangeConexao(ConnectivityStatus? resultado) async {
    if (downloadStatus == EnumDownloadStatus.CONCLUIDO) {
      return;
    }

    if (resultado == ConnectivityStatus.none &&
        (downloadStatus == EnumDownloadStatus.BAIXANDO || downloadStatus == EnumDownloadStatus.ERRO)) {
      downloadStatus = EnumDownloadStatus.PAUSADO;
      downloadManagerStore.pauseAllDownloads();
    } else if (resultado != ConnectivityStatus.none &&
        (downloadStatus == EnumDownloadStatus.PAUSADO || downloadStatus == EnumDownloadStatus.ERRO)) {
      await iniciarDownload();
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

    var connectionStatus = await Connectivity().checkConnectivity();
    if (connectionStatus != ConnectivityStatus.none) {
      try {
        await GetIt.I.get<ApiService>().prova.setStatusProva(
              idProva: id,
              tipoDispositivo: kDeviceType.index,
              status: EnumProvaStatus.INICIADA.index,
            );
      } catch (e) {
        warning(e);
      }
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
      fine('[Prova $id] - Configurando controlador de tempo');

      tempoExecucaoStore = ProvaTempoExecucaoStore(
        horaFinalTurno: ServiceLocator.get<UsuarioStore>().fimTurno,
        duracaoProva: Duration(seconds: prova.tempoExecucao),
        duracaoTempoExtra: Duration(seconds: prova.tempoExtra),
        duracaoTempoFinalizando: Duration(seconds: prova.tempoAlerta ?? 0),
      );
    }
  }

  @action
  setStatusProva(EnumProvaStatus provaStatus) {
    prova.status = provaStatus;
    status = provaStatus;
  }

  saveProva() async {
    AppDatabase db = GetIt.I.get();

    await db.inserirOuAtualizarProva(
      ProvaDb(
        id: prova.id,
        descricao: prova.descricao,
        downloadStatus: prova.downloadStatus,
        tempoExtra: prova.tempoExtra,
        tempoExecucao: prova.tempoExecucao,
        tempoAlerta: prova.tempoAlerta,
        status: prova.status.index,
        itensQuantidade: prova.itensQuantidade,
        dataInicio: prova.dataInicio,
        dataFim: prova.dataFim,
        ultimaAtualizacao: DateTime.now(),
        dataInicioProvaAluno: prova.dataInicioProvaAluno,
        dataFimProvaAluno: prova.dataFimProvaAluno,
        senha: prova.senha,
        quantidadeRespostaSincronizacao: prova.quantidadeRespostaSincronizacao,
      ),
    );
    var provaSalva = await db.obterProvaPorId(prova.id);
    fine('[ULTIMO SALVAMENTO] ${provaSalva.ultimaAtualizacao}');
  }

  @action
  Future<bool> finalizarProva([bool automaticamente = false]) async {
    try {
      BuildContext context = ServiceLocator.get<AppRouter>().navigatorKey.currentContext!;

      ConnectivityStatus resultado = await (Connectivity().checkConnectivity());
      prova.dataFimProvaAluno = DateTime.now();
      setRespondendoProva(false);

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

        await respostas.sincronizarResposta(force: true);

        // Sincroniza com a api
        var response = await GetIt.I.get<ApiService>().prova.setStatusProva(
              idProva: id,
              status: EnumProvaStatus.FINALIZADA.index,
              tipoDispositivo: kDeviceType.index,
              dataFim: getTicks(prova.dataFimProvaAluno!),
            );

        if (response.isSuccessful) {
          // ignore: prefer_typing_uninitialized_variables
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
              AppDatabase db = GetIt.I.get();

              await prefs.remove('prova_${prova.id}');
              await prefs.remove('download_${prova.id}');
              await db.limpar();

              // Remove respostas da prova do cache
              for (var questoes in prova.questoes) {
                var codigoEOL = ServiceLocator.get<UsuarioStore>().codigoEOL;
                await prefs.remove('resposta_${codigoEOL}_${questoes.id}');
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

  bool possuiTempoExecucao() {
    return prova.tempoExecucao > 0;
  }
}
