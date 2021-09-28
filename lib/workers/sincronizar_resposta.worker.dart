import 'dart:convert';

import 'package:appserap/dependencias.ioc.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/interfaces/worker.interface.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SincronizarRespostas with Worker, Loggable {
  final _service = ServiceLocator.get<ApiService>().questaoResposta;

  setup() {
    configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 1,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiredNetworkType: NetworkType.ANY,
      ),
    );
  }

  @override
  onFetch(String taskId) async {
    fine('[BackgroundFetch] Event received.');

    BackgroundFetch.finish(taskId);
  }

  sincronizar() async {
    fine('Sincronizando respostas para o servidor');

    var respostasLocal = carregaRespostasCache();
    fine('${respostasLocal.length} respostas salvas localmente');

    var respostasNaoSincronizadas = respostasLocal.entries.where((element) => element.value.sincronizado == false);
    fine('${respostasNaoSincronizadas.length} respostas não sincronizadas');

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
          fine("[${resposta.questaoId}] Resposta Sincronizada - (${resposta.alternativaId ?? resposta.resposta}");

          resposta.sincronizado = true;

          await saveCahe(resposta);
        }
      } catch (e) {
        severe(e);
      }
    }
    fine('Sincronização com o servidor servidor concluida');
  }

  salvarCacheMap(Map<int, ProvaResposta> respostas) async {
    List<Future<bool>> futures = [];

    for (var respostaLocal in respostas.entries) {
      futures.add(saveCahe(respostaLocal.value));
    }

    await Future.wait(futures);
  }

  saveCahe(ProvaResposta resposta) async {
    SharedPreferences _pref = ServiceLocator.get();

    await _pref.setString(
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
