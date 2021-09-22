import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'prova.view.store.g.dart';

class ProvaViewStore = _ProvaViewStoreBase with _$ProvaViewStore;

abstract class _ProvaViewStoreBase with Store, Loggable {
  final _service = GetIt.I.get<ApiService>().questaoResposta;

  @observable
  List<Questao> questoes = [];

  @observable
  int questaoAtual = 1;

  @observable
  int? resposta = 1;

  @observable
  ObservableList<ProvaResposta> respostas = ObservableList<ProvaResposta>();

  ReactionDisposer? _disposer;

  setup() async {
    _disposer = reaction((_) => respostas.length, onChangeRespostas);
    await obterRespostasServidor();
  }

  void dispose() {
    _disposer!();
  }

  @action
  obterRespostasServidor() async {
    for (var questao in questoes) {
      try {
        var _respostaSalva = await _service.getRespostaPorQuestaoId(questaoId: questao.id);
        print(_respostaSalva);
      } catch (e) {
        severe(e);
      }
    }
  }

  @action
  onChangeRespostas(int tamanho) async {
    for (var resposta in respostas.where((element) => !element.sincronizado).toList()) {
      try {
        await _service.postResposta(
          questaoId: resposta.questaoId,
          alternativaId: resposta.alternativaId,
          resposta: resposta.resposta,
          dataHoraRespostaTicks: getTicks(resposta.dataHoraResposta),
        );
        print("Resposta Salva ${resposta.questaoId} | ${resposta.alternativaId}");

        respostas[respostas.indexOf(resposta)].sincronizado = true;
      } catch (e) {
        severe(e);
      }
    }

    respostas.removeWhere((element) => element.sincronizado);
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
