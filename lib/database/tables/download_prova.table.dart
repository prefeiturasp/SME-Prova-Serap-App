import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:drift/drift.dart';

import 'prova.table.dart';

@DataClassName("DownloadProvaDb")
class DownloadProvasDb extends Table {
  IntColumn get id => integer()();

  IntColumn get provaId => integer()();

  IntColumn get questaoLegadoId => integer().nullable()();
  IntColumn get ordem => integer().nullable()();

  IntColumn get tipo => intEnum<EnumDownloadTipo>()();
  IntColumn get downloadStatus => intEnum<EnumDownloadStatus>()();

  DateTimeColumn get dataHoraInicio => dateTime()();
  DateTimeColumn get dataHoraFim => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id, provaId};
}
