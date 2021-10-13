import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appserap/utils/date.util.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/main.ioc.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/interfaces/worker.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/workers/sincronizar_resposta.worker.dart';
import 'package:workmanager/workmanager.dart';

class FinalizarProvaWorker with Worker, Loggable {
  setup() async {
    if (Platform.isAndroid) {
      await Workmanager().registerPeriodicTask(
        "1",
        "FinalizarProvaWorker",
        frequency: Duration(minutes: 15),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } else {
      Timer.periodic(Duration(minutes: 1), (timer) {
        sincronizar();
      });
    }
  }

  @override
  onFetch(String taskId) {
    fine('[BackgroundFetch] Event received.');

    sincronizar();

    // BackgroundFetch.finish(taskId);
  }

  sincronizar() async {
    fine('Sincronizando provas para o servidor');

    List<Prova> provas = listProvasCache()
        .map((e) => Prova.carregaProvaCache(e)!)
        .where((e) => e.status == EnumProvaStatus.PENDENTE)
        .toList();

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
        await prefs.remove('prova_${prova.id}');

        // Remove respostas da prova do cache
        var respostasSincronizadas = respostasProva.where((element) => element.sincronizado == true).toList();
        info('Total de respostas sincronizadas ${respostasSincronizadas.length}');
        for (var resposta in respostasSincronizadas) {
          await prefs.remove('resposta_${resposta.questaoId}');
        }
      } catch (e) {
        severe(e);
      }
    }
    fine('Sincronização com o servidor servidor concluida');
  }

  List<int> listProvasCache() {
    SharedPreferences prefs = ServiceLocator.get();

    var ids = prefs.getKeys().toList().where((element) => element.startsWith('prova_'));

    if (ids.isNotEmpty) {
      return ids.map((e) => e.replaceAll('prova_', '')).map((e) => int.parse(e)).toList();
    }
    return [];
  }

  List<ProvaResposta> getRespostas(Prova prova) {
    SharedPreferences prefs = ServiceLocator.get();

    List<int> idsQuestoes = prova.questoes.map((e) => e.id).toList();

    List<ProvaResposta> respostas = [];

    for (int idQuestao in idsQuestoes) {
      var respostaJson = prefs.getString('resposta_$idQuestao');

      if (respostaJson != null) {
        respostas.add(ProvaResposta.fromJson(jsonDecode(respostaJson)));
      }
    }

    return respostas;
  }
}
