// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/job_status.enum.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/interfaces/job_config.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.isolate.dart';
import 'package:appserap/stores/job.store.dart';
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
import '../models/job.model.dart' as model;

callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("Native called background task: $task");

    return await executarJobs(task);
  });
}

executarJobs(String task) async {
  final sendPort = IsolateNameServer.lookupPortByName(kIsolateBackground);
  JobsEnum job = JobsEnum.parse(task)!;

  try {
    registerPluginsForIsolate();

    await setupAppConfig();

    setupLogging();

    await DependenciasIoC().setup();

    sendStatus(sendPort, job, EnumJobStatus.EXECUTANDO);

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

    sendStatus(sendPort, job, EnumJobStatus.COMPLETADO);

    return Future.value(true);
  } catch (e, stack) {
    await recordError(e, stack);

    sendStatus(sendPort, job, EnumJobStatus.ERRO);

    return Future.error(e);
  }
}

sendStatus(SendPort? sendPort, JobsEnum job, EnumJobStatus status) {
  var db = ServiceLocator.get<AppDatabase>();

  if (status == EnumJobStatus.EXECUTANDO) {
    db.jobDao.definirUltimaExecucao(job.taskName, ultimaExecucao: DateTime.now());
  }

  db.jobDao.definirStatus(job.taskName, statusUltimaExecucao: status);

  if (sendPort != null) {
    StatusJob statusJob = StatusJob(job, status);
    sendPort.send(statusJob);
  } else {
    ServiceLocator.get<JobStore>().statusJob[job] = status;
  }
}

class Worker with Loggable, Database {
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

    var existe = await db.jobDao.getByName(config.taskName);
    if (existe == null) {
      await db.jobDao.inserirOuAtualizar(model.Job(
        id: config.uniqueName,
        nome: config.taskName,
        intervalo: config.frequency.inSeconds,
      ));
    }

    if (!kIsWeb && Platform.isAndroid) {
      await Workmanager().registerPeriodicTask(
        config.uniqueName,
        config.taskName,
        frequency: config.frequency,
        constraints: config.constraints,
        initialDelay: Duration(minutes: 1),
        backoffPolicy: BackoffPolicy.linear,
      );
    } else {
      await interval(config.frequency, (timer) async {
        info('Executando job ${config.taskName}');

        final JobsEnum jobEnum = JobsEnum.parse(config.taskName)!;

        try {
          sendStatus(null, jobEnum, EnumJobStatus.EXECUTANDO);
          await job.run();
          sendStatus(null, jobEnum, EnumJobStatus.COMPLETADO);
        } catch (e, stack) {
          sendStatus(null, jobEnum, EnumJobStatus.ERRO);
          await recordError(e, stack);
        }
      });
    }
  }
}
