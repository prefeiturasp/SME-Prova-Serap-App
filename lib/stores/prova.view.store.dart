import 'package:appserap/dtos/prova_resposta.dto.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prova.view.store.g.dart';

class ProvaViewStore = _ProvaViewStoreBase with _$ProvaViewStore;

abstract class _ProvaViewStoreBase with Store {
  @observable
  int questaoAtual = 1;

  @observable
  int? resposta = 1;

  @observable
  List<ProvaRespostaDTO> respostas = [];

  @action
  adicionarResposta(int questaoId, int resposta) {
    respostas.add(ProvaRespostaDTO(questaoId: questaoId, respostaAlternativa: resposta));
  }
}
