import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:mobx/mobx.dart';

part 'prova.view.store.g.dart';

class ProvaViewStore = _ProvaViewStoreBase with _$ProvaViewStore;

abstract class _ProvaViewStoreBase with Store, Loggable {
  late ProvaStore provaStore;

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
  bool botaoOcupado = false;

  @observable
  bool mostrarAlertaDeTempoAcabando = false;

  @observable
  bool isLoading = true;

  setup(ProvaStore provaStore) async {
    this.provaStore = provaStore;
    questoesParaRevisar = <Questao>[].asObservable();
    questaoAtual = 1;

    await configurarProva();
  }

  configurarProva() async {
    if (provaStore.prova.status == EnumProvaStatus.NAO_INICIADA) {
      await provaStore.iniciarProva();
    } else {
      await provaStore.continuarProva();
    }
  }

  void dispose() {
    quantidadeDeQuestoesSemRespostas = 0;
    mostrarAlertaDeTempoAcabando = false;
    questoesParaRevisar = <Questao>[].asObservable();
    revisandoProva = false;
  }
}
