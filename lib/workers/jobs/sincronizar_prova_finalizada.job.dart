import 'dart:async';
import 'dart:convert';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/interfaces/job_config.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/workers/sincronizar_resposta.worker.dart';

class SincronizarProvaFinalizadaJob with Job, Loggable {
  @override
  JobConfig configuration() {
    return JobConfig();
  }

  @override
  Future<void> run() async {
    fine('Sincronizando provas para o servidor');
    AppDatabase db = ServiceLocator.get();

    List<ProvaDb> provasDb = await db.obterProvasPendentes();

    List<Prova> provas = provasDb.map((e) => Prova.fromProvaDb(e)).cast<Prova>().toList();

    info('${provas.length} provas pendente de sincronização');

    ConnectivityStatus resultado = await (Connectivity().checkConnectivity());
    if (provas.isNotEmpty && resultado == ConnectivityStatus.none) {
      info('Falha na sincronização. Sem Conexão....');
      return;
    }

    for (var prova in provas) {
      try {
        // Atualiza status servidor
        await ServiceLocator.get<ApiService>().prova.setStatusProva(
              idProva: prova.id,
              status: EnumProvaStatus.FINALIZADA.index,
              dataFim: getTicks(prova.dataFimProvaAluno!),
            );

        // Sincroniza respostas
        var respostasProva = getRespostas(prova);
        info('Sincronizando ${respostasProva.length} respostas');
        await SincronizarRespostasWorker().sincronizar(respostasProva);

        // Remove prova do cache
        SharedPreferences prefs = ServiceLocator.get();
        db.limparPorProvaId(prova.id);

        // Remove respostas da prova do cache
        var respostasSincronizadas = respostasProva.where((element) => element.sincronizado == true).toList();
        info('Total de respostas sincronizadas ${respostasSincronizadas.length}');
        for (var resposta in respostasSincronizadas) {
          var codigoEOL = ServiceLocator.get<UsuarioStore>().codigoEOL;
          await prefs.remove('resposta_${codigoEOL}_${resposta.questaoId}');
        }
      } catch (e) {
        severe(e);
      }
    }
    fine('Sincronização com o servidor servidor concluida');
  }

  List<ProvaResposta> getRespostas(Prova prova) {
    SharedPreferences prefs = ServiceLocator.get();

    List<int> idsQuestoes = prova.questoes.map((e) => e.id).toList();

    List<ProvaResposta> respostas = [];

    var keys = prefs.getKeys();

    for (var key in keys) {
      if (key.startsWith('resposta_')) {
        List<String> infos = key.split('_');
        var idQuestao = infos[2];

        if (idsQuestoes.contains(int.parse(idQuestao))) {
          var respostaJson = prefs.getString(key);

          if (respostaJson != null) {
            respostas.add(ProvaResposta.fromJson(jsonDecode(respostaJson)));
          }
        }
      }
    }

    return respostas;
  }
}
