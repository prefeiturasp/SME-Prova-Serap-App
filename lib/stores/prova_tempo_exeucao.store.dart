import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/managers/tempo.manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'prova_tempo_exeucao.store.g.dart';

class ProvaTempoExecucaoStore = _ProvaTempoExecucaoStoreBase with _$ProvaTempoExecucaoStore;

typedef TimerChangeCallback = void Function(EnumProvaTempoEventType eventType, Duration tempoRestante);

abstract class _ProvaTempoExecucaoStoreBase with Store, Loggable, Disposable {
  List<ReactionDisposer> _reactions = [];

  GerenciadorTempo? gerenciadorTempo;

  late DateTime dataHoraInicioProva;

  Duration duracaoProva;
  Duration duracaoTempoExtra;
  Duration duracaoTempoFinalizando;

  VoidCallback? finalizarProvaCallback;
  VoidCallback? finalizandoProvaCallback;
  VoidCallback? extenderProvaCallback;

  @observable
  EnumProvaTempoEventType status = EnumProvaTempoEventType.INICIADO;

  @observable
  double porcentagem = 0;

  @observable
  int horaFinalTurno;

  @observable
  Duration tempoRestante = Duration(seconds: 0);

  @observable
  bool tempoAcabando = false;

  @observable
  bool mostrarAlertaDeTempoAcabando = false;

  @computed
  bool get isTempoNormalEmExecucao => status == EnumProvaTempoEventType.INICIADO;

  @computed
  bool get isTempoExtendido => status == EnumProvaTempoEventType.EXTENDIDO;

  @computed
  bool get possuiTempoRestante => tempoRestante.inSeconds > 0;

  _ProvaTempoExecucaoStoreBase({
    required this.duracaoProva,
    required this.duracaoTempoExtra,
    required this.duracaoTempoFinalizando,
    required this.horaFinalTurno,
  }) {
    setupReactions();
  }

  @action
  iniciarContador(
    DateTime dataHoraInicioProva,
  ) {
    finer('Iniciando contador de tempo');
    this.dataHoraInicioProva = dataHoraInicioProva;
    configure();
  }

  setupReactions() {
    _reactions = [
      reaction((_) => status, onStatusChange),
      reaction((_) => tempoAcabando, onAlertaTempoChange),
    ];
  }

  onAlertaTempoChange(bool tempoAcabando) {
    if (tempoAcabando) {
      if (finalizandoProvaCallback != null) {
        finalizandoProvaCallback!();
      }
      mostrarAlertaDeTempoAcabando = true;
    }
  }

  onStatusChange(EnumProvaTempoEventType status) {
    switch (status) {
      case EnumProvaTempoEventType.EXTENDIDO:
        if (extenderProvaCallback != null) {
          extenderProvaCallback!();
        }
        mostrarAlertaDeTempoAcabando = false;
        break;

      case EnumProvaTempoEventType.FINALIZADO:
        if (finalizarProvaCallback != null) {
          finalizarProvaCallback!();
        }

        break;

      default:
        break;
    }
  }

  @action
  configure() {
    gerenciadorTempo = GerenciadorTempo();

    gerenciadorTempo!.onChangeDuracao((TempoChangeData changeData) {
      status = changeData.eventType;
      porcentagem = changeData.porcentagemTotal;
      tempoRestante = changeData.tempoRestante;
      tempoAcabando = changeData.tempoAcabando;
    });

    gerenciadorTempo!.configure(
      horaFinalTurno: horaFinalTurno,
      dataHoraInicioProva: dataHoraInicioProva,
      duracaoProva: duracaoProva,
      duracaoTempoExtra: duracaoTempoExtra,
      duracaoTempoFinalizando: duracaoTempoFinalizando,
    );
  }

  onFinalizarlProva(finalizarProvaCallback) {
    this.finalizarProvaCallback = finalizarProvaCallback;
  }

  onFinalizandoProva(finalizandoProvaCallback) {
    this.finalizandoProvaCallback = finalizandoProvaCallback;
  }

  onExtenderProva(extenderProvaCallback) {
    this.extenderProvaCallback = extenderProvaCallback;
  }

  @override
  onDispose() async {
    await gerenciadorTempo?.onDispose();
    finalizarProvaCallback = null;
    finalizandoProvaCallback = null;
    extenderProvaCallback = null;

    tempoAcabando = false;
    tempoRestante = Duration(seconds: 0);

    for (var reaction in _reactions) {
      reaction();
    }

    _reactions = [];
  }
}
