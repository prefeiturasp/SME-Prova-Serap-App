import 'package:appserap/models/prova_aluno.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(ProvaAluno)
class ProvaAlunoTable extends Table {
  TextColumn get codigoEOL => text()();
  IntColumn get provaId => integer()();

  @override
  Set<Column> get primaryKey => {codigoEOL, provaId};
}
