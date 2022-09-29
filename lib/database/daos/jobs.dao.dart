import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/jobs.table.dart';
import 'package:appserap/enums/job_status.enum.dart';
import 'package:appserap/models/job.model.dart';
import 'package:appserap/workers/jobs.enum.dart';
import 'package:drift/drift.dart';

part 'jobs.dao.g.dart';

@DriftAccessor(tables: [JobsTable])
class JobDao extends DatabaseAccessor<AppDatabase> with _$JobDaoMixin {
  JobDao(AppDatabase db) : super(db);

  Future inserir(Job entity) {
    return into(jobsTable).insert(entity);
  }

  Future inserirOuAtualizar(Job entity) {
    return into(jobsTable).insertOnConflictUpdate(entity);
  }

  Future remover(Job entity) {
    return delete(jobsTable).delete(entity);
  }

  Future<List<Job>> listarTodos() {
    return select(jobsTable).get();
  }

  Future<int> definirUltimaExecucao(String jobNome, {DateTime? ultimaExecucao}) async {
    return (update(jobsTable)
          ..where(
            (t) => t.nome.equals(jobNome),
          ))
        .write(
      JobsTableCompanion(
        ultimaExecucao: Value(ultimaExecucao),
      ),
    );
  }

  Future<int> definirStatus(String jobNome, {EnumJobStatus? statusUltimaExecucao}) async {
    return (update(jobsTable)
          ..where(
            (t) => t.nome.equals(jobNome),
          ))
        .write(
      JobsTableCompanion(
        statusUltimaExecucao: Value(statusUltimaExecucao),
      ),
    );
  }

  Future<Job?> getByJobName(JobsEnum job) {
    return (select(jobsTable)..where((t) => t.nome.equals(job.taskName))).getSingleOrNull();
  }

  Stream<Job> watchJob(JobsEnum job) {
    var query = (select(jobsTable)..where((t) => t.nome.equals(job.taskName)));

    return query.watchSingle();
  }
}
