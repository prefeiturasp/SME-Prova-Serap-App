// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/interfaces/job_config.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/utils/timer.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../main.ioc.dart';
import '../main.dart';
import 'jobs.enum.dart';
import 'jobs/finalizar_prova_pendente.job.dart';
import 'jobs/remover_provas.job.dart';
import 'jobs/sincronizar_respostas.job.dart';

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
          await SincronizarRespostasJob().run();
          break;

        case JobsEnum.FINALIZAR_PROVA:
          await FinalizarProvasPendenteJob().run();
          break;

        case JobsEnum.REMOVER_PROVAS_EXPIRADAS:
          await RemoverProvasJob().run();
          break;
      }

      return Future.value(true);
    } catch (e, stack) {
      await recordError(e, stack);

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
    await configure(FinalizarProvasPendenteJob());
    await configure(SincronizarRespostasJob());
    await configure(RemoverProvasJob());
  }

  configure(Job job) async {
    JobConfig config = job.configuration();

    info('Configurando task a cada ${config.frequency} - ${config.taskName}');

    if (!kIsWeb && Platform.isAndroid) {
      await Workmanager().registerPeriodicTask(
        config.uniqueName,
        config.taskName,
        frequency: config.frequency,
        constraints: config.constraints,
        initialDelay: Duration(minutes: 1),
        existingWorkPolicy: ExistingWorkPolicy.replace,
        backoffPolicy: BackoffPolicy.linear,
      );
    } else {
      await interval(config.frequency, (timer) async {
        info('Executando job ${config.taskName}');
        await job.run();
      });
    }
  }
}
