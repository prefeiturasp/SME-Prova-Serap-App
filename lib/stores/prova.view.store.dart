import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:mobx/mobx.dart';

part 'prova.view.store.g.dart';

class ProvaViewStore = _ProvaViewStoreBase with _$ProvaViewStore;

abstract class _ProvaViewStoreBase with Store, Loggable {
  @observable
  int questaoAtual = 0;

  @observable
  ObservableMap<int, bool> questoesRevisao = <int, bool>{}.asObservable();

  @observable
  int quantidadeDeQuestoesSemRespostas = 0;

  @observable
  bool revisandoProva = false;

  @observable
  bool mostrarAlertaDeTempoAcabando = false;

  setup() async {
    questoesRevisao = <int, bool>{}.asObservable();
    questaoAtual = 1;
  }

  void dispose() {
    quantidadeDeQuestoesSemRespostas = 0;
    mostrarAlertaDeTempoAcabando = false;
    questoesRevisao = <int, bool>{}.asObservable();
    revisandoProva = false;
  }
}
