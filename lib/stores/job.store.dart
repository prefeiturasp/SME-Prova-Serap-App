import 'package:appserap/enums/job_status.enum.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/workers/jobs.enum.dart';
import 'package:mobx/mobx.dart';
part 'job.store.g.dart';

class JobStore = _JobStoreBase with _$JobStore;

abstract class _JobStoreBase with Store, Database {
  late List<ReactionDisposer> _disposers;

  @observable
  ObservableMap<JobsEnum, EnumJobStatus> statusJob = ObservableMap.of({});

  _JobStoreBase() {
    db.jobDao.listarTodos().then((value) {
      for (var jobValue in value) {
        var status = jobValue.statusUltimaExecucao;
        status ??= EnumJobStatus.COMPLETADO;

        var job = JobsEnum.parse(jobValue.nome)!;

        statusJob[job] = status;
      }
    });

    _disposers = [
      reaction((_) => statusJob, updateDatabase),
    ];
  }

  updateDatabase(ObservableMap<JobsEnum, EnumJobStatus> statusJob) {
    for (var element in statusJob.entries) {
      if (element.value == EnumJobStatus.EXECUTANDO) {
        db.jobDao.definirUltimaExecucao(element.key.taskName, ultimaExecucao: DateTime.now());
      }

      db.jobDao.definirStatus(element.key.taskName, statusUltimaExecucao: element.value);
    }
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}

class StatusJob {
  JobsEnum job;
  EnumJobStatus status;

  StatusJob(
    this.job,
    this.status,
  );
}
