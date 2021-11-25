import 'dart:async';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/utils/extensions/date.extension.dart';
import 'package:get_it/get_it.dart';

typedef DuracaoChangeCallback = void Function(TempoChangeData changeData);

enum EnumProvaTempoEventType { INICIADO, EXTENDIDO, FINALIZADO }

class GerenciadorTempo with Loggable, Disposable {
  late DateTime dataHoraInicioProva;

  late Duration duracaoProva;
  Duration? duracaoTempoExtra;
  late Duration duracaoTempoFinalizando;

  late int horaFinalTurno;

  bool tempoAcabando = false;

  EnumProvaTempoEventType estagioTempo = EnumProvaTempoEventType.INICIADO;

  DuracaoChangeCallback? _onChangeDuracaoCallback;

  Timer? timer;
  Timer? timerAdicional;
  Timer? timerFinalTurno;

  Duration intervaloAtualizacao = Duration(milliseconds: 500);

  configure({
    required DateTime dataHoraInicioProva,
    required Duration duracaoProva,
    required Duration duracaoTempoExtra,
    required Duration duracaoTempoFinalizando,
    required int horaFinalTurno,
  }) {
    this.dataHoraInicioProva = dataHoraInicioProva;
    this.duracaoProva = duracaoProva;
    this.duracaoTempoExtra = duracaoTempoExtra;
    this.duracaoTempoFinalizando = duracaoTempoFinalizando;
    this.horaFinalTurno = horaFinalTurno;

    if (_onChangeDuracaoCallback != null) {
      _onChangeDuracaoCallback!(
        TempoChangeData(
          eventType: EnumProvaTempoEventType.INICIADO,
          porcentagemTotal: 0,
          tempoRestante: duracaoProva,
          tempoAcabando: tempoAcabando,
        ),
      );
    }

    timer = Timer.periodic(intervaloAtualizacao, (_) => process());
    timerFinalTurno = Timer.periodic(intervaloAtualizacao, (_) => processFinalTurno());
  }

  iniciarTimerFinalTurno() {}

  iniciarTimerProvaExtendida() {
    timerAdicional = Timer.periodic(intervaloAtualizacao, (_) => processAdicional());
  }

  processFinalTurno() {
    var tempoRestante =
        DateTime.now().copyWith(hour: horaFinalTurno, minute: 0, second: 0, millisecond: 0).difference(DateTime.now());

    if (tempoRestante.inSeconds < 0) {
      if (_onChangeDuracaoCallback != null) {
        _onChangeDuracaoCallback!(
          TempoChangeData(
            eventType: EnumProvaTempoEventType.FINALIZADO,
            porcentagemTotal: 1,
            tempoRestante: Duration(
              seconds: tempoRestante.inSeconds,
            ),
            tempoAcabando: true,
          ),
        );

        timer?.cancel();
        timerAdicional?.cancel();
        timerFinalTurno?.cancel();
      }
    }
  }

  process() {
    var tempoRestante = dataHoraInicioProva.add(duracaoProva).difference(DateTime.now());

    var porcentagemDecorrida = ((tempoRestante.inMilliseconds / duracaoProva.inMilliseconds) - 1) * -1;

    if (tempoRestante < duracaoTempoFinalizando) {
      tempoAcabando = true;
    } else {
      tempoAcabando = false;
    }

    if (porcentagemDecorrida > 1) {
      porcentagemDecorrida = 0;
      timer?.cancel();

      bool possuiTempoExtra = duracaoTempoExtra != null && duracaoTempoExtra!.inSeconds > 0;

      if (possuiTempoExtra) {
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
          tempoRestante: Duration(
            seconds: tempoRestante.inSeconds,
          ),
          tempoAcabando: tempoAcabando,
        ),
      );
    }
  }

  processAdicional() {
    var tempoRestante = dataHoraInicioProva.add(duracaoProva + duracaoTempoExtra!).difference(DateTime.now());

    var porcentagemDecorrida = ((tempoRestante.inMilliseconds / duracaoTempoExtra!.inMilliseconds) - 1) * -1;

    if (tempoRestante < duracaoTempoFinalizando) {
      tempoAcabando = true;
    } else {
      tempoAcabando = false;
    }

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
          tempoAcabando: tempoAcabando,
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
    timerFinalTurno?.cancel();
  }
}

class TempoChangeData {
  EnumProvaTempoEventType eventType;
  double porcentagemTotal;
  Duration tempoRestante;
  bool tempoAcabando;

  TempoChangeData({
    required this.eventType,
    required this.porcentagemTotal,
    required this.tempoRestante,
    required this.tempoAcabando,
  });
}
