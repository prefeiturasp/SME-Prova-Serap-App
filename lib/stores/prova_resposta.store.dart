import 'dart:convert';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.ioc.dart';

part 'prova_resposta.store.g.dart';

class ProvaRespostaStore = _ProvaRespostaStoreBase with _$ProvaRespostaStore;

abstract class _ProvaRespostaStoreBase with Store, Loggable {
  final _service = GetIt.I.get<ApiService>().questaoResposta;

  @observable
  int idProva;

  _ProvaRespostaStoreBase({required this.idProva}) {
    respostasLocal = carregaRespostasCache().asObservable();
  }

  @observable
  ObservableMap<int, ProvaResposta> respostasSalvas = <int, ProvaResposta>{}.asObservable();

  @observable
  ObservableMap<int, ProvaResposta> respostasLocal = <int, ProvaResposta>{}.asObservable();

  @action
  carregarRespostasServidor([Prova? prova]) async {
    fine('[$idProva] - Carregando respostas da prova');

    List<int> idsQuestao = [];

    prova ??= Prova.carregaProvaCache(idProva);

    if (prova != null) {
      idsQuestao = prova.questoes.map((e) => e.id).toList();
    }
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
        //severe(e);
      }
    }

    fine('[$idProva] - ${respostasSalvas.length} respostas carregadas do banco de dados remoto');
  }

  ProvaResposta? obterResposta(int questaoId) {
    var respostaRemota = respostasSalvas[questaoId];
    var respostaLocal = respostasLocal[questaoId];

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
    //TODO carregar cache local

    fine('[$idProva] - Sincronizando respostas para o servidor');
    var respostasNaoSincronizadas = respostasLocal.entries.where((element) => element.value.sincronizado == false);

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

    salvarAllCache();
  }

  @action
  definirResposta(int questaoId, {int? alternativaId, String? textoResposta}) {
    var resposta = ProvaResposta(
      questaoId: questaoId,
      alternativaId: alternativaId,
      resposta: textoResposta,
      sincronizado: false,
      dataHoraResposta: DateTime.now(),
    );

    respostasLocal[questaoId] = resposta;

    salvarCache(resposta);
  }

  salvarAllCache() async {
    List<Future<bool>> futures = [];

    for (var respostaLocal in respostasLocal.entries) {
      futures.add(salvarCache(respostaLocal.value));
    }

    await Future.wait(futures);
  }

  salvarCache(ProvaResposta resposta) async {
    SharedPreferences _pref = GetIt.I.get();

    return await _pref.setString(
      'resposta_${resposta.questaoId}',
      jsonEncode(resposta.toJson()),
    );
  }

  Map<int, ProvaResposta> carregaRespostasCache() {
    SharedPreferences _pref = ServiceLocator.get();

    List<String> keysResposta = _pref.getKeys().toList().where((element) => element.startsWith('resposta_')).toList();

    Map<int, ProvaResposta> respostas = {};

    if (keysResposta.isNotEmpty) {
      for (var keyResposta in keysResposta) {
        var provaResposta = ProvaResposta.fromJson(jsonDecode(_pref.getString(keyResposta)!));

        respostas[provaResposta.questaoId] = provaResposta;
      }
    }

    return respostas;
  }
}
