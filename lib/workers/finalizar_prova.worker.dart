import 'dart:async';
import 'dart:io';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/foundation.dart';

import 'package:appserap/main.ioc.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/interfaces/worker.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/workers/sincronizar_resposta.worker.dart';
import 'package:workmanager/workmanager.dart';

class FinalizarProvaWorker with Worker, Loggable {
  setup() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return await Workmanager().registerPeriodicTask(
          "1",
          "FinalizarProvaWorker",
          frequency: Duration(minutes: 15),
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
        );
      } else {
        return Timer.periodic(Duration(minutes: 15), (timer) {
          sincronizar();
        });
      }
    }

    Timer.periodic(Duration(minutes: 1), (timer) {
      sincronizar();
    });
  }

  @override
  onFetch(String taskId) {
    fine('[BackgroundFetch] Event received.');

    sincronizar();

    // BackgroundFetch.finish(taskId);
  }

  sincronizar() async {
    AppDatabase db = ServiceLocator.get();

    fine('Sincronizando provas para o servidor');

    List<ProvaDb> provasDb = await db.provaDao.obterPendentes();

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
              tipoDispositivo: kDeviceType.index,
              dataFim: getTicks(prova.dataFimProvaAluno!),
            );

        // Sincroniza respostas
        var respostasProva = await db.respostaProvaDao.obterNaoSincronizadasPorProva(prova.id);
        info('Sincronizando ${respostasProva.length} respostas');
        await SincronizarRespostasWorker().sincronizar(respostasProva);

        // Remove respostas do banco local
        await db.respostaProvaDao.removerSincronizadasPorProva(prova.id);
      } catch (e) {
        severe(e);
      }
    }
    fine('Sincronização com o servidor servidor concluida');
  }
}
