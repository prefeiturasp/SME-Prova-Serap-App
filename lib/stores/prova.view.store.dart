import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'prova.view.store.g.dart';

class ProvaViewStore = _ProvaViewStoreBase with _$ProvaViewStore;

abstract class _ProvaViewStoreBase with Store, Loggable {
  @observable
  int questaoAtual = 0;

  @observable
  int quantidadeDeQuestoesSemRespostas = 0;

  @observable
  bool revisandoProva = false;

  @observable
  String questaoConstruida = '';

  setup() async {
    questaoAtual = 1;
  }

  void dispose() {
    quantidadeDeQuestoesSemRespostas = 0;
    revisandoProva = false;
  }
  
}
