// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/utils/timer.util.dart';
import 'package:appserap/workers/jobs/remover_provas.job.dart';
import 'package:appserap/workers/sincronizar_resposta.worker.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../main.ioc.dart';
import '../main.dart';
import 'finalizar_prova.worker.dart';
import 'jobs.enum.dart';

callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: $task");

    try {
      registerPluginsForIsolate();
      setupLogging();
      await setupAppConfig();
      await DependenciasIoC().setup();

      JobsEnum job = JobsEnum.parse(task)!;

      switch (job) {
        case JobsEnum.SINCRONIZAR_RESPOSTAS:
          await SincronizarRespostasWorker().sincronizar();
          break;

        case JobsEnum.FINALIZAR_PROVA:
          await FinalizarProvaWorker().sincronizar();
          break;

        case JobsEnum.REMOVER_PROVAS_EXPIRADAS:
          await RemoverProvasJob().run();
          break;
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
      if (Platform.isAndroid) {
        await Workmanager().initialize(
          callbackDispatcher,
          isInDebugMode: false,
        );
      }
    }

    await registerWorkers();
  }

  Future<void> registerWorkers() async {
    await SincronizarRespostasWorker().setup();
    await FinalizarProvaWorker().setup();

    await configure(RemoverProvasJob());
  }

  configure(Job job) async {
    info('Configurando task ${job.configuration().taskName}');

    if (!kIsWeb && Platform.isAndroid) {
      await Workmanager().registerPeriodicTask(
        job.configuration().uniqueName,
        job.configuration().taskName,
        frequency: job.configuration().frequency,
        constraints: job.configuration().constraints,
      );
    } else {
      await interval(job.configuration().frequency, (timer) async {
        info('Executando job ${job.configuration().taskName}');
        await job.run();
      });
    }
  }
}
