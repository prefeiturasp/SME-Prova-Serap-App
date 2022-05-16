import 'package:drift/drift.dart';

@DataClassName("ArquivoVideoDb")
class ArquivosVideoDb extends Table {
  IntColumn get id => integer()();
  TextColumn get path => text()();
  IntColumn get questaoId => integer()();
  IntColumn get provaId => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
