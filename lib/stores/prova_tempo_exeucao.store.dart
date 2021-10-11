import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/managers/tempo.manager.dart';

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
  Duration tempoRestante = Duration(seconds: 0);

  @observable
  bool tempoAcabando = false;

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
  }) {
    setupReactions();
  }

  @action
  iniciarContador(
    DateTime dataHoraInicioProva,
  ) {
    finer('Iniciando contador de tempo');
    this.dataHoraInicioProva = dataHoraInicioProva;
    configugure();
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
    }
  }

  onStatusChange(EnumProvaTempoEventType status) {
    switch (status) {
      case EnumProvaTempoEventType.EXTENDIDO:
        if (extenderProvaCallback != null) {
          extenderProvaCallback!();
        }
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
  configugure() {
    gerenciadorTempo = GerenciadorTempo();

    gerenciadorTempo!.configure(
      dataHoraInicioProva: dataHoraInicioProva,
      duracaoProva: duracaoProva,
      duracaoTempoExtra: duracaoTempoExtra,
      duracaoTempoFinalizando: duracaoTempoFinalizando,
    );

    gerenciadorTempo!.onChangeDuracao((TempoChangeData changeData) {
      status = changeData.eventType;
      porcentagem = changeData.porcentagemTotal;
      tempoRestante = changeData.tempoRestante;
      tempoAcabando = changeData.tempoAcabando;
    });
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
  onDispose() {
    gerenciadorTempo?.onDispose();
    finalizarProvaCallback = null;
    finalizandoProvaCallback = null;
    extenderProvaCallback = null;

    for (var reaction in _reactions) {
      reaction();
    }

    _reactions = [];
  }
}
