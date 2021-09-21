import 'package:appserap/dtos/prova_resposta.dto.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:mobx/mobx.dart';

part 'prova.view.store.g.dart';

class ProvaViewStore = _ProvaViewStoreBase with _$ProvaViewStore;

abstract class _ProvaViewStoreBase with Store {
  @observable
  int questaoAtual = 1;

  @observable
  int? resposta = 1;

  @observable
  ObservableList<ProvaResposta> respostas = ObservableList<ProvaResposta>();

  ReactionDisposer? _disposer;

  setup() {
    _disposer = reaction((_) => respostas.length, onChangeRespostas);
  }

  void dispose() {
    _disposer!();
  }

  @action
  onChangeRespostas(int tamanho) {
    print(tamanho);
  }

  @action
  adicionarResposta(int questaoId, int resposta) {
    respostas.add(
      ProvaResposta(
        questaoId: questaoId,
        alternativaId: resposta,
        sincronizado: false,
        dataHoraResposta: DateTime.now(),
      ),
    );
  }
}
