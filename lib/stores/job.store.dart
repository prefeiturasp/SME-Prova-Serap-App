import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/enums/job_status.enum.dart';
import 'package:appserap/workers/jobs.enum.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'job.store.g.dart';

@Singleton()
class JobStore = _JobStoreBase with _$JobStore;

abstract class _JobStoreBase with Store {
  final AppDatabase db;
  final RespostasDatabase dbRespostas;

  @observable
  ObservableMap<JobsEnum, EnumJobStatus> statusJob = ObservableMap.of({});

  _JobStoreBase(
    this.db,
    this.dbRespostas,
  ) {
    db.jobDao.listarTodos().then((value) {
      for (var jobValue in value) {
        var status = jobValue.statusUltimaExecucao;
        status ??= EnumJobStatus.COMPLETADO;

        var job = JobsEnum.parse(jobValue.nome)!;

        statusJob[job] = status;
      }
    });
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
