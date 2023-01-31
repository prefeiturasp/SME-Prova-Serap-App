import 'package:appserap/models/resposta_prova.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(RespostaProva)
class RespostaProvaTable extends Table {
  TextColumn get codigoEOL => text()();

  IntColumn get questaoId => integer()();
  IntColumn get provaId => integer()();
  TextColumn get caderno => text().withDefault(Constant("A"))();
  TextColumn get dispositivoId => text()();

  IntColumn get alternativaId => integer().nullable()();
  IntColumn get ordem => integer().nullable()();
  TextColumn get resposta => text().nullable()();

  IntColumn get tempoRespostaAluno => integer()();
  DateTimeColumn get dataHoraResposta => dateTime().withDefault(currentDateAndTime).nullable()();

  BoolColumn get sincronizado => boolean()();

  @override
  Set<Column> get primaryKey => {codigoEOL, provaId, caderno, questaoId};
}
