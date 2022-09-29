import 'package:appserap/enums/job_status.enum.dart';
import 'package:appserap/models/job.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(Job)
class JobsTable extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();

  IntColumn get statusUltimaExecucao => intEnum<EnumJobStatus>().nullable()();
  DateTimeColumn get ultimaExecucao => dateTime().nullable()();

  IntColumn get intervalo => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
