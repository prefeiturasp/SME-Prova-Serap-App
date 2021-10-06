import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'package:appserap/interfaces/loggable.interface.dart';

typedef DuracaoChangeCallback = void Function(TempoChangeData changeData);

enum EnumProvaTempoEventType { INICIADO, EM_EXECUCAO, ACABANDO, EXTENDIDO, FINALIZADO }

class GerenciadorTempo with Loggable, Disposable {
  late DateTime dataHoraInicioProva;

  late Duration duracaoProva;
  Duration? duracaoTempoExtra;
  late Duration duracaoTempoFinalizando;

  EnumProvaTempoEventType estagioTempo = EnumProvaTempoEventType.INICIADO;

  DuracaoChangeCallback? _onChangeDuracaoCallback;

  Timer? timer;
  Timer? timerAdicional;

  configure({
    required DateTime dataHoraInicioProva,
    required Duration duracaoProva,
    required Duration duracaoTempoExtra,
    required Duration duracaoTempoFinalizando,
  }) {
    this.dataHoraInicioProva = dataHoraInicioProva;
    this.duracaoProva = duracaoProva;
    this.duracaoTempoExtra = duracaoTempoExtra;
    this.duracaoTempoFinalizando = duracaoTempoFinalizando;

    if (_onChangeDuracaoCallback != null) {
      _onChangeDuracaoCallback!(
        TempoChangeData(
          eventType: EnumProvaTempoEventType.INICIADO,
          porcentagemTotal: 0,
          tempoRestante: duracaoProva,
        ),
      );
    }

    timer = Timer.periodic(Duration(milliseconds: 100), (_) => process());
  }

  process() {
    var tempoRestante = dataHoraInicioProva.add(duracaoProva).difference(DateTime.now());

    var porcentagemDecorrida = ((tempoRestante.inMilliseconds / duracaoProva.inMilliseconds) - 1) * -1;

    if (tempoRestante < duracaoTempoFinalizando || duracaoProva.inMinutes < 5 && porcentagemDecorrida > 0.85) {
      estagioTempo = EnumProvaTempoEventType.ACABANDO;
    }

    if (porcentagemDecorrida > 1) {
      porcentagemDecorrida = 0;
      timer?.cancel();

      if (duracaoTempoExtra != null && duracaoTempoExtra!.inSeconds > 0) {
        estagioTempo = EnumProvaTempoEventType.EXTENDIDO;
        iniciarTimerProvaExtendida();
      } else {
        estagioTempo = EnumProvaTempoEventType.FINALIZADO;
      }
    }
    if (_onChangeDuracaoCallback != null) {
      _onChangeDuracaoCallback!(
        TempoChangeData(
          eventType: estagioTempo,
          porcentagemTotal: porcentagemDecorrida,
          tempoRestante: Duration(seconds: tempoRestante.inSeconds),
        ),
      );
    }
  }

  iniciarTimerProvaExtendida() {
    timerAdicional = Timer.periodic(Duration(milliseconds: 100), (_) => processAdicional());
  }

  processAdicional() {
    var tempoRestante = dataHoraInicioProva.add(duracaoProva + duracaoTempoExtra!).difference(DateTime.now());

    var porcentagemDecorrida = ((tempoRestante.inMilliseconds / duracaoTempoExtra!.inMilliseconds) - 1) * -1;

    if (porcentagemDecorrida > 1) {
      porcentagemDecorrida = 0;
      timerAdicional?.cancel();

      estagioTempo = EnumProvaTempoEventType.FINALIZADO;
    }

    if (_onChangeDuracaoCallback != null) {
      _onChangeDuracaoCallback!(
        TempoChangeData(
          eventType: estagioTempo,
          porcentagemTotal: porcentagemDecorrida,
          tempoRestante: Duration(seconds: tempoRestante.inSeconds),
        ),
      );
    }
  }

  onChangeDuracao(DuracaoChangeCallback onChangeDuracaoCallback) {
    _onChangeDuracaoCallback = onChangeDuracaoCallback;
  }

  @override
  onDispose() {
    timer?.cancel();
    timerAdicional?.cancel();
  }
}

class TempoChangeData {
  EnumProvaTempoEventType eventType;
  double porcentagemTotal;
  Duration tempoRestante;

  TempoChangeData({
    required this.eventType,
    required this.porcentagemTotal,
    required this.tempoRestante,
  });
}
