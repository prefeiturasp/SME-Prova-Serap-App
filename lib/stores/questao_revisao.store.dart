import 'package:appserap/models/questao.model.dart';
import 'package:mobx/mobx.dart';

part 'questao_revisao.store.g.dart';

class QuestaoRevisaoStore = _QuestaoRevisaoStoreBase with _$QuestaoRevisaoStore;

abstract class _QuestaoRevisaoStoreBase with Store {
  @observable
  ObservableList<Questao> questoesParaRevisar = <Questao>[].asObservable();

  @observable
  ObservableList<Map<String, dynamic>> mapaDeQuestoes = ObservableList.of([]);

  @observable
  int posicaoQuestaoSendoRevisada = 0;

  @observable
  int totalDeQuestoesParaRevisar = 0;

  @observable
  int quantidadeDeQuestoesSemRespostas = 0;

  @observable
  bool botaoOcupado = false;

  @observable
  bool botaoFinalizarOcupado = false;

  @observable
  bool isLoading = false;
}
