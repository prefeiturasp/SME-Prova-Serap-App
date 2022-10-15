import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/models/resposta_prova.model.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:mobx/mobx.dart';

part 'questao_revisao.store.g.dart';

class QuestaoRevisaoStore = _QuestaoRevisaoStoreBase with _$QuestaoRevisaoStore;

abstract class _QuestaoRevisaoStoreBase with Store, Database, Loggable {
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

  Future<int?> obterProximaQuestaoRevisao(ProvaStore provaStore, int questaoLegadoId, int ordemAtual) async {
    var questoes = await db.questaoDao.obterPorProvaECaderno(provaStore.id, provaStore.caderno);

    for (var i = ordemAtual + 1; i < questoes.length; i++) {
      var podeRevisar = await podeRevisarQuestao(provaStore, questoes[i].questaoLegadoId);

      if (podeRevisar) {
        return i;
      }
    }

    return null;
  }

  Future<bool> podeRevisarQuestao(ProvaStore provaStore, int questaoLegadoId) async {
    int questaoId = await db.provaCadernoDao.obterQuestaoIdPorProvaECadernoEQuestao(
      provaStore.id,
      provaStore.caderno,
      questaoLegadoId,
    );

    RespostaProva? resposta = provaStore.respostas.obterResposta(questaoId);
    var alternativas = await db.alternativaDao.obterPorQuestaoLegadoId(questaoLegadoId);

    String alternativaSelecionada = "";
    for (var alternativa in alternativas) {
      if (resposta != null) {
        if (alternativa.id == resposta.alternativaId) {
          alternativaSelecionada = alternativa.numeracao;
        }
      }
    }

    bool podeRevisar = true;

    bool questaoNaoRespondida = resposta == null ||
        (resposta.alternativaId == null && (resposta.resposta == null || resposta.resposta!.isEmpty)) ||
        alternativaSelecionada.isEmpty;

    bool naoEstaTempoEstendido =
        provaStore.tempoExecucaoStore != null && !provaStore.tempoExecucaoStore!.isTempoExtendido;

    if (questaoNaoRespondida && !naoEstaTempoEstendido) {
      podeRevisar = false;
    }

    return podeRevisar;
  }
}
