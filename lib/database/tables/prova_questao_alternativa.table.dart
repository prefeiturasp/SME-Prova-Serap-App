import 'package:appserap/models/prova_questao_alternativa.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(ProvaQuestaoAlternativa)
class ProvaQuestaoAlternativaTable extends Table {
  IntColumn get questaoId => integer()();
  IntColumn get questaoLegadoId => integer()();
  IntColumn get alternativaId => integer()();
  IntColumn get alternativaLegadoId => integer()();
  IntColumn get provaId => integer()();
  TextColumn get caderno => text()();
  IntColumn get ordem => integer()();

  @override
  Set<Column> get primaryKey => {provaId, caderno, questaoLegadoId, alternativaLegadoId};
}
