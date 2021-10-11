import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:mobx/mobx.dart';

part 'prova.view.store.g.dart';

class ProvaViewStore = _ProvaViewStoreBase with _$ProvaViewStore;

abstract class _ProvaViewStoreBase with Store, Loggable {
  @observable
  int questaoAtual = 0;

  @observable
  ObservableList<Questao> questoesParaRevisar = <Questao>[].asObservable();

  @observable
  int posicaoQuestaoSendoRevisada = 0;

  @observable
  int totalDeQuestoesParaRevisar = 0;

  @observable
  int quantidadeDeQuestoesSemRespostas = 0;

  @observable
  bool revisandoProva = false;

  @observable
  bool isBusy = false;

  @observable
  bool mostrarAlertaDeTempoAcabando = false;

  @observable
  bool isLoading = true;

  setup() async {
    questoesParaRevisar = <Questao>[].asObservable();
    questaoAtual = 1;
  }

  void dispose() {
    quantidadeDeQuestoesSemRespostas = 0;
    mostrarAlertaDeTempoAcabando = false;
    questoesParaRevisar = <Questao>[].asObservable();
    revisandoProva = false;
  }
}
