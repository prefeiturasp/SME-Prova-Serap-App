import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/gerenciador_tempo.service.dart';

part 'prova_tempo_exeucao.store.g.dart';

class ProvaTempoExecucao = _ProvaTempoExecucaoBase with _$ProvaTempoExecucao;

abstract class _ProvaTempoExecucaoBase with Store, Loggable, Disposable {
  @observable
  double porcentagem = 0;

  Duration duracaoProva;

  @observable
  Duration tempoRestante = Duration(seconds: 0);

  late DateTime dataHoraInicioProva;

  late GerenciadorTempo gerenciadorTempo;

  _ProvaTempoExecucaoBase({
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
      info('Prova finalizada');
    });
  }

  @override
  onDispose() {
    gerenciadorTempo.onDispose();
  }
}
