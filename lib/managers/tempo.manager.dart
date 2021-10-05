import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import 'package:appserap/interfaces/loggable.interface.dart';

typedef DuracaoChangeCallback = void Function(double porcentagemTotal, Duration tempoRestante);

class GerenciadorTempo with Loggable, Disposable {
  late Duration duration;
  late DateTime dataHoraInicioProva;
  DuracaoChangeCallback? _onChangeDuracaoCallback;
  VoidCallback? _onDuracaoEndCallback;

  Timer? timer;

  configure({required DateTime dataHoraInicioProva, required Duration duration}) {
    this.dataHoraInicioProva = dataHoraInicioProva;
    this.duration = duration;

    process();
    timer = Timer.periodic(Duration(milliseconds: 100), (_) => process());
  }

  process() {
    var tempoRestante = dataHoraInicioProva.add(duration).difference(DateTime.now());

    var porcentagemDecorrida = ((tempoRestante.inMilliseconds / duration.inMilliseconds) - 1) * -1;

    if (porcentagemDecorrida > 1) {
      porcentagemDecorrida = 1;
      timer?.cancel();
      if (_onDuracaoEndCallback != null) {
        _onDuracaoEndCallback!();
      }
    }

    if (_onChangeDuracaoCallback != null) {
      _onChangeDuracaoCallback!(porcentagemDecorrida, Duration(seconds: tempoRestante.inSeconds));
    }
  }

  onChangeDuracao(DuracaoChangeCallback onChangeDuracaoCallback) {
    _onChangeDuracaoCallback = onChangeDuracaoCallback;
  }

  onDuracaoEnd(VoidCallback onDuracaoEndCallback) {
    _onDuracaoEndCallback = onDuracaoEndCallback;
  }

  @override
  onDispose() {
    timer?.cancel();
  }
}
