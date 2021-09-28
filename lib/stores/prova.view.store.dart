import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'prova.view.store.g.dart';

class ProvaViewStore = _ProvaViewStoreBase with _$ProvaViewStore;

abstract class _ProvaViewStoreBase with Store, Loggable {
  @observable
  int questaoAtual = 1;

  @observable
  int quantidadeDeQuestoesSemRespostas = 0;

  @observable
  bool revisandoProva = false;

  setup() async {
    questaoAtual = 1;
  }
}
