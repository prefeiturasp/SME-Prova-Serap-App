import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'questao_revisao.store.g.dart';

@LazySingleton()
class QuestaoRevisaoStore = _QuestaoRevisaoStoreBase with _$QuestaoRevisaoStore;

abstract class _QuestaoRevisaoStoreBase with Store, Loggable {
  final AppDatabase db;
  final RespostasDatabase dbRespostas;

  @observable
  ObservableMap<int, Questao> questoesParaRevisar = <int, Questao>{}.asObservable();

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

  _QuestaoRevisaoStoreBase(
    this.db,
    this.dbRespostas,
  );
}
