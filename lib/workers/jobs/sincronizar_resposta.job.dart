import 'dart:async';
import 'dart:convert';

import 'package:appserap/interfaces/job_config.interface.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/utils/date.util.dart';

class SincronizarRespostaJob with Job, Loggable {
  @override
  JobConfig configuration() {
    return JobConfig();
  }

  @override
  Future<void> run() async {
    fine('Sincronizando respostas para o servidor');

    var respostasLocal = carregaRespostasCache();
    finer('${respostasLocal.length} respostas salvas localmente');

    var respostasNaoSincronizadas = respostasLocal.where((element) => element.sincronizado == false);
    fine('${respostasNaoSincronizadas.length} respostas ainda não sincronizadas');

    ConnectivityStatus resultado = await (Connectivity().checkConnectivity());
    if (respostasNaoSincronizadas.isNotEmpty && resultado == ConnectivityStatus.none) {
      info('Falha na sincronização. Sem Conexão....');
      return;
    }

    for (ProvaResposta resposta in respostasNaoSincronizadas) {
      await sincronizarResposta(resposta);
    }

    fine('Sincronização com o servidor servidor concluida');
  }

  sincronizarResposta(ProvaResposta resposta) async {
    int idQuestao = resposta.questaoId;
    final _service = ServiceLocator.get<ApiService>().questaoResposta;

    try {
      var response = await _service.postResposta(
        chaveAPI: AppConfigReader.getChaveApi(),
        alunoRa: resposta.codigoEOL,
        questaoId: idQuestao,
        alternativaId: resposta.alternativaId,
        resposta: resposta.resposta,
        dataHoraRespostaTicks: getTicks(resposta.dataHoraResposta!),
        tempoRespostaAluno: resposta.tempoRespostaAluno,
      );

      if (response.isSuccessful) {
        fine("[${resposta.questaoId}] Resposta Sincronizada - ${resposta.alternativaId ?? resposta.resposta}");

        resposta.sincronizado = true;

        await saveCahe(resposta);
      }
    } catch (e) {
      severe(e);
    }
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
      'resposta_${resposta.codigoEOL}_${resposta.questaoId}',
      jsonEncode(resposta.toJson()),
    );
  }

  List<ProvaResposta> carregaRespostasCache() {
    SharedPreferences _pref = GetIt.I.get();

    List<String> keysResposta = _pref.getKeys().toList().where((element) => element.startsWith('resposta_')).toList();

    List<ProvaResposta> respostas = [];

    if (keysResposta.isNotEmpty) {
      for (var keyResposta in keysResposta) {
        var provaResposta = ProvaResposta.fromJson(jsonDecode(_pref.getString(keyResposta)!));

        respostas.add(provaResposta);
      }
    }

    return respostas;
  }
}
