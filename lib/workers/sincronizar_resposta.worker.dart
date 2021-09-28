import 'dart:async';
import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/dependencias.ioc.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/interfaces/worker.interface.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/utils/date.util.dart';

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

    Timer.periodic(Duration(seconds: 30), (timer) {
      sincronizar();
    });
  }

  @override
  onFetch(String taskId) async {
    fine('[BackgroundFetch] Event received.');

    sincronizar();

    if (taskId.isNotEmpty) {
      BackgroundFetch.finish(taskId);
    }
  }

  sincronizar() async {
    fine('Sincronizando respostas para o servidor');

    var respostasLocal = carregaRespostasCache();
    print(respostasLocal);
    info('${respostasLocal.length} respostas salvas localmente');

    var respostasNaoSincronizadas = respostasLocal.entries.where((element) => element.value.sincronizado == false);
    info('${respostasNaoSincronizadas.length} respostas ainda não sincronizadas');

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
          info("[${resposta.questaoId}] Resposta Sincronizada - ${resposta.alternativaId ?? resposta.resposta}");

          resposta.sincronizado = true;

          await saveCahe(resposta);
        }
      } catch (e) {
        severe(e);
      }
    }
    info('Sincronização com o servidor servidor concluida');
  }

  salvarCacheMap(Map<int, ProvaResposta> respostas) async {
    List<Future<bool>> futures = [];

    for (var respostaLocal in respostas.entries) {
      futures.add(saveCahe(respostaLocal.value));
    }

    await Future.wait(futures);
  }

  saveCahe(ProvaResposta resposta) async {
    SharedPreferences _pref = GetIt.I.get();

    return await _pref.setString(
      'resposta_${resposta.questaoId}',
      jsonEncode(resposta.toJson()),
    );
  }

  Map<int, ProvaResposta> carregaRespostasCache() {
    SharedPreferences _pref = GetIt.I.get();

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
