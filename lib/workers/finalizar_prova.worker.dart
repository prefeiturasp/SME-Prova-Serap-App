import 'dart:async';
import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

import 'package:appserap/dependencias.ioc.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/interfaces/worker.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/workers/sincronizar_resposta.worker.dart';

class FinalizarProvaWorker with Worker, Loggable {
  setup() {
    if (!kIsWeb) {
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

    Timer.periodic(Duration(seconds: 30), (timer) {
      sincronizar();
    });
  }

  @override
  onFetch(String taskId) {
    fine('[BackgroundFetch] Event received.');

    sincronizar();

    BackgroundFetch.finish(taskId);
  }

  sincronizar() async {
    fine('Sincronizando provas para o servidor');

    List<Prova> provas = listProvasCache()
        .map((e) => Prova.carregaProvaCache(e)!)
        .where((e) => e.status == EnumProvaStatus.PENDENTE)
        .toList();

    info('${provas.length} provas pendente de sincronização');

    ConnectivityResult resultado = await (Connectivity().checkConnectivity());
    if (provas.isNotEmpty && resultado == ConnectivityResult.none) {
      info('Falha na sincronização. Sem Conexão....');
      return;
    }

    for (var prova in provas) {
      try {
        // Atualiza status servidor
        await ServiceLocator.get<ApiService>().prova.setStatusProva(
              idProva: prova.id,
              status: EnumProvaStatus.FINALIZADA.index,
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
