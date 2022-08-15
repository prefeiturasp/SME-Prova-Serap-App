import 'package:appserap/models/arquivo.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(Arquivo)
class ArquivosDb extends Table {
  IntColumn get id => integer()();
  IntColumn get legadoId => integer()();
  TextColumn get caminho => text()();
  TextColumn get base64 => text()();

  @override
  Set<Column> get primaryKey => {id};
}
