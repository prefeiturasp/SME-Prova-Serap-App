import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/questao_arquivo.table.dart';
import 'package:appserap/models/questao_arquivo.model.dart';
import 'package:drift/drift.dart';

part 'questao_arquivo.dao.g.dart';

@DriftAccessor(tables: [QuestaoArquivoTable])
class QuestaoArquivoDao extends DatabaseAccessor<AppDatabase> with _$QuestaoArquivoDaoMixin {
  QuestaoArquivoDao(AppDatabase db) : super(db);

  Future inserir(QuestaoArquivo entity) {
    return into(questaoArquivoTable).insert(entity);
  }

  Future inserirOuAtualizar(QuestaoArquivo entity) {
    return into(questaoArquivoTable).insertOnConflictUpdate(entity);
  }

  Future remover(QuestaoArquivo entity) {
    return delete(questaoArquivoTable).delete(entity);
  }

  Future<List<QuestaoArquivo>> findByArquivoLegadoId(int arquivoLegadoId) {
    return (select(questaoArquivoTable)..where((t) => t.arquivoLegadoId.equals(arquivoLegadoId))).get();
  }

  Future<QuestaoArquivo?> findByQuestaoLegadoId(int questaoLegadoId) {
    return (select(questaoArquivoTable)..where((t) => t.questaoLegadoId.equals(questaoLegadoId))).getSingleOrNull();
  }

  Future<List<QuestaoArquivo>> listarTodos() {
    return select(questaoArquivoTable).get();
  }

  Future<int> removerPorQuestaoLegadoId(int questaoLegadoId) {
    return transaction(() async {
      return await (delete(questaoArquivoTable)..where((t) => t.questaoLegadoId.equals(questaoLegadoId))).go();
    });
  }
}
