import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/arquivo_video.table.dart';
import 'package:drift/drift.dart';

part 'arquivo_video.dao.g.dart';

@DriftAccessor(tables: [ArquivosVideoDb])
class ArquivosVideosDao extends DatabaseAccessor<AppDatabase> with _$ArquivosVideosDaoMixin {
  ArquivosVideosDao(AppDatabase db) : super(db);

  Future inserir(ArquivoVideoDb entity) {
    return into(arquivosVideoDb).insert(entity);
  }

  Future inserirOuAtualizar(ArquivoVideoDb entity) {
    return into(arquivosVideoDb).insertOnConflictUpdate(entity);
  }

  Future remover(ArquivoVideoDb entity) {
    return delete(arquivosVideoDb).delete(entity);
  }

  Future<ArquivoVideoDb?> findByQuestaoLegadoId(int questaoLegadoId) {
    return (select(arquivosVideoDb)..where((t) => t.questaoLegadoId.equals(questaoLegadoId))).getSingleOrNull();
  }

  Future<List<ArquivoVideoDb>> listarTodos() {
    return select(arquivosVideoDb).get();
  }

  Future<ArquivoVideoDb?> findById(int id) {
    return (select(arquivosVideoDb)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<ArquivoVideoDb?> obterPorQuestaoLegadoId(int questaoLegadoId) {
    return (select(arquivosVideoDb)..where((t) => t.questaoLegadoId.equals(questaoLegadoId))).getSingleOrNull();
  }
}
