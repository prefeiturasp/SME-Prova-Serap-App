import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  int quantidadeDeQuestoesSemRespostas = 0;

  @observable
  bool revisandoProva = false;

  @observable
  ObservableMap<int, ProvaResposta> respostas = <int, ProvaResposta>{}.asObservable();

  @observable
  ObservableMap<int, ProvaResposta> respostasSalvas = <int, ProvaResposta>{}.asObservable();

  setup() async {
    await obterRespostasServidor();
    questaoAtual = 1;
  }

  void dispose() {
    respostasSalvas = <int, ProvaResposta>{}.asObservable();
  }

  @action
  obterRespostasServidor() async {
    for (var questao in questoes) {
      try {
        var respostaBanco = await _service.getRespostaPorQuestaoId(questaoId: questao.id);
        if (respostaBanco.isSuccessful) {
          var body = respostaBanco.body!;

          respostasSalvas[questao.id] = ProvaResposta(
            questaoId: questao.id,
            sincronizado: true,
            alternativaId: body.alternativaId,
            resposta: body.resposta,
            dataHoraResposta: body.dataHoraResposta.toLocal(),
          );

          fine("Resposta Banco Questao ${questao.id} - ${body.alternativaId} | ${body.resposta}");
        }
      } catch (e) {
        severe(e);
      }
    }
  }

  ProvaResposta? obterResposta(int questaoId) {
    var respostaRemota = respostasSalvas[questaoId];
    var respostaLocal = respostas[questaoId];

    if (respostaRemota != null && respostaLocal != null) {
      if (respostaRemota.dataHoraResposta!.isBefore(respostaLocal.dataHoraResposta!)) {
        return respostaLocal;
      } else {
        return respostaRemota;
      }
    }

    return respostaRemota ?? respostaLocal;
  }

  @action
  sincronizarResposta() async {
    for (MapEntry<int, ProvaResposta> item
        in respostas.entries.where((element) => element.value.sincronizado == false)) {
      int idQuestao = item.key;
      ProvaResposta resposta = item.value;

      try {
        var response = await _service.postResposta(
          questaoId: idQuestao,
          alternativaId: resposta.alternativaId,
          resposta: resposta.resposta,
          dataHoraRespostaTicks: getTicks(resposta.dataHoraResposta!),
        );

        if (response.isSuccessful) {
          fine("Resposta Sincronizada - ${resposta.questaoId} | ${resposta.alternativaId}");

          resposta.sincronizado = true;
        }
      } catch (e) {
        severe(e);
      }
    }
  }

  @action
  definirResposta(int questaoId, int? resposta) {
    respostas[questaoId] = ProvaResposta(
      questaoId: questaoId,
      alternativaId: resposta,
      sincronizado: false,
      dataHoraResposta: DateTime.now(),
    );
  }
}
