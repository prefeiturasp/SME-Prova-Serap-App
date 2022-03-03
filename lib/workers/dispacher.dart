// ignore_for_file: avoid_print

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/workers/sincronizar_resposta.worker.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../main.ioc.dart';
import '../main.dart';
import 'finalizar_prova.worker.dart';

callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: $task");

    try {
      setupLogging();
      await setupAppConfig();
      await DependenciasIoC().setup();

      if (task == "SincronizarRespostasWorker") {
        await SincronizarRespostasWorker().sincronizar();
      } else if (task == "FinalizarProvaWorker") {
        await FinalizarProvaWorker().sincronizar();
      }

      return Future.value(true);
    } catch (e, stacktrace) {
      print('ERRO: $e');
      print(stacktrace);
      return Future.error(e);
    }
  });
}

class Worker with Loggable {
  setup() async {
    config('Configurando Workers');

    if (!kIsWeb) {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: false,
      );
    }

    await registerWorkers();
  }

  Future<void> registerWorkers() async {
    await SincronizarRespostasWorker().setup();
    await FinalizarProvaWorker().setup();
  }
}
