import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(Questao)
class QuestoesDb extends Table {
  IntColumn get questaoLegadoId => integer()();
  TextColumn get titulo => text().nullable()();
  TextColumn get descricao => text()();
  IntColumn get tipo => intEnum<EnumTipoQuestao>()();
  DateTimeColumn get ultimaAtualizacao => dateTime().nullable()();
  IntColumn get quantidadeAlternativas => integer()();

  @override
  Set<Column> get primaryKey => {questaoLegadoId};
}
