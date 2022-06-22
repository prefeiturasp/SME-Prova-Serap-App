import 'package:appserap/models/arquivo.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(Arquivo)
class ArquivosDb extends Table {
  IntColumn get id => integer()();
  IntColumn get legadoId => integer()();
  TextColumn get caminho => text()();
  TextColumn get base64 => text()();
  DateTimeColumn get ultimaAtualizacao => dateTime().nullable()();
  IntColumn get provaId => integer()();
  IntColumn get questaoId => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
