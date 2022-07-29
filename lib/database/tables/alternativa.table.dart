import 'package:drift/drift.dart';

@DataClassName("AlternativaDb")
class AlternativasDb extends Table {
  IntColumn get id => integer()();
  TextColumn get descricao => text()();
  IntColumn get ordem => integer()();
  TextColumn get numeracao => text()();
  DateTimeColumn get ultimaAtualizacao => dateTime().nullable()();
  IntColumn get provaId => integer()();
  IntColumn get questaoId => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
