import 'dart:convert';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prova_resposta.store.g.dart';

class ProvaRespostaStore = _ProvaRespostaStoreBase with _$ProvaRespostaStore;

abstract class _ProvaRespostaStoreBase with Store, Loggable {
  final _service = GetIt.I.get<ApiService>().questaoResposta;

  @observable
  int idProva;

  _ProvaRespostaStoreBase({required this.idProva});

  @observable
  ObservableMap<int, ProvaResposta> respostasSalvas = <int, ProvaResposta>{}.asObservable();

  @observable
  ObservableMap<int, ProvaResposta> respostas = <int, ProvaResposta>{}.asObservable();

  void dispose() {
    respostasSalvas = <int, ProvaResposta>{}.asObservable();
  }

  @action
  carregarRespostasServidor([Prova? prova]) async {
    fine('[$idProva] - Carregando respostas da prova');

    List<int> idsQuestao = [];

    prova ??= carregaProvaCache();

    if (prova != null) {
      idsQuestao = prova.questoes.map((e) => e.id).toList();
    }
    fine('[$idProva] - Carregando resposta das questoes $idsQuestao');
    for (var idQuestao in idsQuestao) {
      try {
        var respostaBanco = await _service.getRespostaPorQuestaoId(questaoId: idQuestao);
        if (respostaBanco.isSuccessful) {
          var body = respostaBanco.body!;

          respostasSalvas[idQuestao] = ProvaResposta(
            questaoId: idQuestao,
            sincronizado: true,
            alternativaId: body.alternativaId,
            resposta: body.resposta,
            dataHoraResposta: body.dataHoraResposta.toLocal(),
          );

          finer("[$idProva] - Resposta Banco Questao $idQuestao - ${body.alternativaId} | ${body.resposta}");
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
    fine('[$idProva] - Sincronizando respostas para o servidor');
    var respostasNaoSincronizadas = respostas.entries.where((element) => element.value.sincronizado == false);

    for (MapEntry<int, ProvaResposta> item in respostasNaoSincronizadas) {
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
          fine("[$idProva] - Resposta Sincronizada - ${resposta.questaoId} | ${resposta.alternativaId}");

          resposta.sincronizado = true;
        }
      } catch (e) {
        severe(e);
      }
    }
    fine('[$idProva] - Sincronização com o servidor servidor concluida');
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

  Prova? carregaProvaCache() {
    var _pref = GetIt.I.get<SharedPreferences>();

    String? provaJson = _pref.getString('prova_$idProva');

    if (provaJson != null) {
      return Prova.fromJson(jsonDecode(provaJson));
    }
  }
}
