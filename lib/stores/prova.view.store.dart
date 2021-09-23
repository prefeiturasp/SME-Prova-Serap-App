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

  @observable
  ObservableList<ProvaResposta> respostasSalvas = ObservableList<ProvaResposta>();

  ReactionDisposer? _disposer;

  setup() async {
    _disposer = reaction((_) => respostas.length, onChangeRespostas);
    await obterRespostasServidor();
    questaoAtual = 1;
  }

  void dispose() {
    _disposer!();
    respostasSalvas = ObservableList<ProvaResposta>();
  }

  @action
  obterRespostasServidor() async {
    for (var questao in questoes) {
      try {
        var respostaBanco = await _service.getRespostaPorQuestaoId(questaoId: questao.id);
        if (respostaBanco.isSuccessful) {
          var body = respostaBanco.body!;

          respostasSalvas.add(
            ProvaResposta(
              questaoId: questao.id,
              sincronizado: true,
              alternativaId: body.alternativaId,
              resposta: body.resposta,
            ),
          );

          print("Resposta Banco ${body.alternativaId} | ${body.resposta}");
        }
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
          dataHoraRespostaTicks: getTicks(resposta.dataHoraResposta!),
        );
        fine("Resposta Salva ${resposta.questaoId} | ${resposta.alternativaId}");

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
    this.resposta = null;
  }
}
