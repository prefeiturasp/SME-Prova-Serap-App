import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/managers/tempo.manager.dart';

part 'prova_tempo_exeucao.store.g.dart';

class ProvaTempoExecucaoStore = _ProvaTempoExecucaoStoreBase with _$ProvaTempoExecucaoStore;

enum EnumProvaTempoEventType { INICIADO, EXTENDIDO, FINALIZADO }

typedef TimerChangeCallback = void Function(EnumProvaTempoEventType eventType, Duration tempoRestante);

abstract class _ProvaTempoExecucaoStoreBase with Store, Loggable, Disposable {
  @observable
  double porcentagem = 0;

  Duration duracaoProva;

  TimerChangeCallback? timerChangeCallback;

  @observable
  Duration tempoRestante = Duration(seconds: 0);

  late DateTime dataHoraInicioProva;

  late GerenciadorTempo gerenciadorTempo;

  _ProvaTempoExecucaoStoreBase({
    required this.dataHoraInicioProva,
    required this.duracaoProva,
  });

  @action
  iniciarProva() {
    configugure();
  }

  configugure() {
    gerenciadorTempo = GerenciadorTempo();
    gerenciadorTempo.configure(dataHoraInicioProva: dataHoraInicioProva, duration: duracaoProva);
    gerenciadorTempo.onChangeDuracao((porcentagem, tempoRestante) {
      this.porcentagem = porcentagem;
      this.tempoRestante = tempoRestante;
    });

    gerenciadorTempo.onDuracaoEnd(() {
      onChange(EnumProvaTempoEventType.FINALIZADO);
    });
  }

  addListener(TimerChangeCallback timerChangeCallback) {
    this.timerChangeCallback = timerChangeCallback;
  }

  onChange(EnumProvaTempoEventType eventType) {
    if (timerChangeCallback != null) {
      timerChangeCallback!(eventType, tempoRestante);
    }
  }

  @override
  onDispose() {
    gerenciadorTempo.onDispose();
    timerChangeCallback = null;
  }
}
