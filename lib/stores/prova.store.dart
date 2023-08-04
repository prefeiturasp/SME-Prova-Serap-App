import 'dart:async';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/tratamento_imagem.enum.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/managers/download.manager.store.dart';
import 'package:appserap/managers/tempo.manager.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/notificacao.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

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
import 'package:wakelock_plus/wakelock_plus.dart';

import 'principal.store.dart';

part 'prova.store.g.dart';

class ProvaStore extends _ProvaStoreBase with _$ProvaStore {
  ProvaStore({
    required Prova prova,
  }) : super(id: prova.id, caderno: prova.caderno, prova: prova) {
    downloadManagerStore = DownloadManagerStore(provaStore: this);
    respostas = ProvaRespostaStore(idProva: id, caderno: prova.caderno);
  }
}

abstract class _ProvaStoreBase with Store, Loggable, Disposable, Database {
  var _usuarioStore = ServiceLocator.get<UsuarioStore>();
  List<ReactionDisposer> _reactions = [];

  late DownloadManagerStore downloadManagerStore;

  late ProvaRespostaStore respostas;

  int id;
  String caderno;

  @observable
  bool isVisible = true;

  @observable
  Prova prova;

  @observable
  TratamentoImagemEnum tratamentoImagem = TratamentoImagemEnum.BASE64;

  DateTime? ultimaAtualizacaoLogImagem;

  _ProvaStoreBase({
    required this.id,
    required this.caderno,
    required this.prova,
  }) {
    status = prova.status;
    downloadStatus = prova.downloadStatus;
  }

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

    fine("[Prova $id - $caderno] - Configurando Download");

    downloadManagerStore.listen((downloadStatus, progressoDownload, tempoPrevisto) {
      this.downloadStatus = downloadStatus;
      this.progressoDownload = progressoDownload;
      this.tempoPrevisto = tempoPrevisto;
    });

    downloadManagerStore.onTempoPrevistoChange((tempoPrevisto) {
      this.tempoPrevisto = tempoPrevisto;
    });

    downloadManagerStore.onError((mensagem) {
      NotificacaoUtil.showSnackbarError(mensagem);
    });

    await downloadManagerStore.iniciarDownload();

    await respostas.carregarRespostasServidor();

    fine("[Prova $id - $caderno] - Download Concluído");
  }

  @action
  configure() {
    _setupReactions();
    _configurarTempoExecucao();
  }

  _setupReactions() {
    fine('[Prova $id - $caderno] - Configurando reactions');
    _reactions = [
      reaction((_) => downloadStatus, onStatusChange),
      reaction(
        (_) => ServiceLocator.get<PrincipalStore>().temConexao,
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
      info("[Prova $id - $caderno] - Download Pausado");
      downloadStatus = EnumDownloadStatus.PAUSADO;
      downloadManagerStore.pauseAllDownloads();
    }
    if (!isRepondendoProva && downloadStatus == EnumDownloadStatus.PAUSADO) {
      info("[Prova $id - $caderno] - Download Resumido");

      await iniciarDownload();
    }
  }

  @action
  Future onChangeConexao(bool temConexao) async {
    if (downloadStatus == EnumDownloadStatus.CONCLUIDO) {
      return;
    }

    if (!temConexao && (downloadStatus == EnumDownloadStatus.BAIXANDO || downloadStatus == EnumDownloadStatus.ERRO)) {
      downloadStatus = EnumDownloadStatus.PAUSADO;
      downloadManagerStore.pauseAllDownloads();
    } else if (temConexao &&
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
    await setStatusProva(EnumProvaStatus.INICIADA);
    await setHoraInicioProva(DateTime.now());

    if (ServiceLocator.get<PrincipalStore>().temConexao) {
      try {
        await GetIt.I.get<ApiService>().prova.setStatusProva(
              idProva: id,
              tipoDispositivo: kDeviceType.index,
              status: EnumProvaStatus.INICIADA.index,
              dataInicio: getTicks(prova.dataInicioProvaAluno!),
            );
      } catch (e, stack) {
        await recordError(e, stack);
      }
    }

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

  @action
  configurarProva() async {
    info("[Prova $id - $caderno] - Configurando prova");

    setRespondendoProva(true);

    await respostas.carregarRespostasServidor();
    await _configureControlesTempoProva();

    await WakelockPlus.enable();

    if (prova.status == EnumProvaStatus.NAO_INICIADA) {
      await iniciarProva();
    } else {
      await continuarProva();
    }

    info("[Prova $id - $caderno] - Configuração concluida");
  }

  _configureControlesTempoProva() async {
    info("[Prova $id - $caderno] - Configurando controles de tempo");
    if (tempoExecucaoStore != null) {
      switch (tempoExecucaoStore!.status) {
        case EnumProvaTempoEventType.EXTENDIDO:
          await _iniciarRevisaoProva();
          break;
        case EnumProvaTempoEventType.FINALIZADO:
          await _finalizarProva();
          break;

        default:
          break;
      }
    }

    if (tempoExecucaoStore != null) {
      tempoExecucaoStore!.onFinalizandoProva(() {
        fine('Prova quase acabando');
      });

      tempoExecucaoStore!.onExtenderProva(() async {
        fine('Prova extendida');
        await _iniciarRevisaoProva();
      });

      tempoExecucaoStore!.onFinalizarlProva(() async {
        fine('Prova finalizada');
        await _finalizarProva();
      });
    }
  }

  Future<void> _iniciarRevisaoProva() async {
    await respostas.sincronizarResposta(force: true);

    ServiceLocator.get<AppRouter>().router.go("/prova/$id/resumo");
  }

  Future<void> _finalizarProva() async {
    var confirm = await finalizarProva(true);
    if (confirm) {
      ServiceLocator.get<AppRouter>().router.go("/");
    }
  }

  /// Configura o tempo de execução da prova
  @action
  _configurarTempoExecucao() {
    if (prova.tempoExecucao > 0) {
      fine('[Prova $id - $caderno] - Configurando controlador de tempo');

      tempoExecucaoStore = ProvaTempoExecucaoStore(
        horaFinalTurno: ServiceLocator.get<UsuarioStore>().fimTurno,
        duracaoProva: Duration(seconds: prova.tempoExecucao),
        duracaoTempoExtra: Duration(seconds: prova.tempoExtra),
        duracaoTempoFinalizando: Duration(seconds: prova.tempoAlerta ?? 0),
      );
    }
  }

  @action
  setStatusProva(EnumProvaStatus provaStatus) async {
    prova.status = provaStatus;
    status = provaStatus;
    await ServiceLocator.get<AppDatabase>().provaDao.atualizarStatus(id, caderno, provaStatus);
  }

  @action
  Future<int> setHoraFimProva(DateTime dataFimProvaAluno) async {
    prova.dataFimProvaAluno = dataFimProvaAluno;
    return await ServiceLocator.get<AppDatabase>().provaDao.atualizaDataFimProvaAluno(id, caderno, dataFimProvaAluno);
  }

  @action
  Future<int> setHoraInicioProva(DateTime dataInicioProvaAluno) async {
    prova.dataInicioProvaAluno = dataInicioProvaAluno;
    return await ServiceLocator.get<AppDatabase>()
        .provaDao
        .atualizaDataInicioProvaAluno(id, caderno, dataInicioProvaAluno);
  }

  @action
  Future<bool> finalizarProva([bool automaticamente = false]) async {
    bool confirmacao = false;

    try {
      BuildContext context = ServiceLocator.get<AppRouter>().navigatorKey.currentContext!;

      setRespondendoProva(false);

      await setHoraFimProva(DateTime.now());

      if (!ServiceLocator.get<PrincipalStore>().temConexao) {
        warning('Prova finalizada sem internet. Sincronização Pendente.');
        // Se estiver sem internet alterar status para pendente (worker ira sincronizar)

        await setStatusProva(EnumProvaStatus.PENDENTE);

        var retorno = await mostrarDialogSemInternet(context);
        return retorno ?? false;
      } else {
        // Atualiza para finalizada
        await setStatusProva(EnumProvaStatus.FINALIZADA);

        await respostas.sincronizarResposta(force: true);

        // Sincroniza com a api
        var response = await GetIt.I.get<ApiService>().prova.setStatusProva(
              idProva: id,
              status: EnumProvaStatus.FINALIZADA.index,
              tipoDispositivo: kDeviceType.index,
              dataInicio: getTicks(prova.dataInicioProvaAluno!),
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

          await dbRespostas.respostaProvaDao.removerSincronizadas();

          confirmacao = retorno ?? false;
        } else {
          switch (response.statusCode) {
            // Prova ja finalizada
            case 411:
              // Remove respostas do banco local
              await dbRespostas.respostaProvaDao.removerSincronizadasPorProva(id);

              mostrarDialogProvaJaEnviada(context);
              break;
          }
        }
      }

      confirmacao = true;
    } catch (e, stack) {
      await recordError(e, stack);
      confirmacao = false;
    }

    await onDispose();

    await WakelockPlus.disable();

    return confirmacao;
  }

  @action
  removerDownload([bool manterRegistroProva = false]) async {
    await downloadManagerStore.removerDownloadCompleto(manterRegistroProva);
  }

  @override
  onDispose() {
    for (var _reaction in _reactions) {
      _reaction();
    }
    tempoExecucaoStore?.onDispose();
    tempoExecucaoStore = null;
  }

  bool possuiTempoExecucao() {
    return prova.tempoExecucao > 0;
  }
}
