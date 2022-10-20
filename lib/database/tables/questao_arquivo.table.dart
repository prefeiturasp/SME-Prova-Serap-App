import 'package:appserap/models/questao_arquivo.model.dart';
import 'package:drift/drift.dart';

@UseRowClass(QuestaoArquivo)
class QuestaoArquivoTable extends Table {
  IntColumn get questaoLegadoId => integer()();
  IntColumn get arquivoLegadoId => integer()();

  @override
  Set<Column> get primaryKey => {questaoLegadoId, arquivoLegadoId};
}
