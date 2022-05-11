import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:drift/drift.dart';

@DataClassName("QuestaoDb")
class QuestoesDb extends Table {
  IntColumn get id => integer()();
  TextColumn get titulo => text()();
  TextColumn get descricao => text()();
  IntColumn get ordem => integer()();
  IntColumn get tipo => intEnum<EnumTipoQuestao>()();
  DateTimeColumn get ultimaAtualizacao => dateTime().nullable()();
  IntColumn get provaId => integer()();
  IntColumn get quantidadeAlternativas => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
