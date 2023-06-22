import 'package:drift/drift.dart';

@DataClassName("ArquivoVideoDb")
class ArquivosVideoDb extends Table {
  IntColumn get id => integer()();
  IntColumn get questaoLegadoId => integer()();
  TextColumn get path => text()();
  TextColumn get caminho => text()();

  @override
  Set<Column> get primaryKey => {id};
}
