import 'package:appserap/database/tables/questao.table.dart';
import 'package:appserap/models/prova_caderno.model.dart';
import 'package:drift/drift.dart';

import 'prova.table.dart';

@UseRowClass(ProvaCaderno)
class ProvaCadernoTable extends Table {
  IntColumn get questaoId => integer()();
  IntColumn get questaoLegadoId => integer()();
  IntColumn get provaId => integer()();
  TextColumn get caderno => text()();
  IntColumn get ordem => integer()();

  @override
  Set<Column> get primaryKey => {questaoLegadoId, provaId, caderno};
}
