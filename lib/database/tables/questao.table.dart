import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(Questao)
class QuestoesDb extends Table {
  IntColumn get id => integer()();
  TextColumn get titulo => text().nullable()();
  TextColumn get descricao => text()();
  IntColumn get ordem => integer()();
  IntColumn get tipo => intEnum<EnumTipoQuestao>()();
  DateTimeColumn get ultimaAtualizacao => dateTime().nullable()();
  IntColumn get provaId => integer()();
  IntColumn get quantidadeAlternativas => integer()();

  TextColumn get caderno => text().withDefault(Constant("A"))();

  @override
  Set<Column> get primaryKey => {id, caderno};
}
