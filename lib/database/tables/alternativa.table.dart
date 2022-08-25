import 'package:appserap/models/alternativa.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(Alternativa)
class AlternativasDb extends Table {
  IntColumn get id => integer()();
  IntColumn get questaoLegadoId => integer()();
  TextColumn get descricao => text()();
  IntColumn get ordem => integer()();
  TextColumn get numeracao => text()();

  @override
  Set<Column> get primaryKey => {id};
}
