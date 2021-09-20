import 'package:appserap/dtos/prova_alternativa.dto.dart';
import 'package:appserap/dtos/prova_arquivo.dto.dart';
import 'package:appserap/dtos/prova_questao.dto.dart';
import 'package:appserap/dtos/prova_resposta.dto.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prova_atual.store.g.dart';

class ProvaAtualStore = _ProvaAtualStoreBase with _$ProvaAtualStore;

abstract class _ProvaAtualStoreBase with Store {
  @observable
  int questaoAtual = 1;

  @observable
  int? resposta = 1;

  @observable
  List<ProvaArquivoDTO> arquivos = [];

  @observable
  List<ProvaQuestaoDTO> questoes = [];

  @observable
  List<ProvaAlternativaDTO> alternativas = [];

  @observable
  String descricao = "";

  @observable
  List<ProvaRespostaDTO> respostas = [];

  @action
  carregarProva(int provaId) async {
    var prefs = await SharedPreferences.getInstance();

    var obterProva = prefs.getString("prova_serap_$provaId");

    if (obterProva != null) {}
  }

  @action
  adicionarResposta(int questaoId, int resposta) {
    respostas.add(new ProvaRespostaDTO(questaoId: questaoId, resposta: resposta));
  }
}
