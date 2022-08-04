import 'package:appserap/models/prova_caderno.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(ProvaCaderno)
class ProvaCadernoTable extends Table {
  IntColumn get questaoLegadId => integer()();
  IntColumn get provaId => integer()();
  TextColumn get caderno => text()();
  IntColumn get ordem => integer()();

  @override
  Set<Column> get primaryKey => {questaoLegadId, provaId, caderno};
}
