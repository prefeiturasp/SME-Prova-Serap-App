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

  Future<List<ArquivoVideoDb>> obterPorProvaId(int provaId) {
    return (select(arquivosVideoDb)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<List<ArquivoVideoDb>> obterPorQuestaoId(int questaoId) {
    return (select(arquivosVideoDb)..where((t) => t.questaoId.equals(questaoId))).get();
  }

  Future<List<ArquivoVideoDb>> listarTodos() {
    return select(arquivosVideoDb).get();
  }

  Future removerContextoPorProvaId(int provaId) {
    return transaction(() async {
      await (delete(arquivosVideoDb)..where((t) => t.provaId.equals(provaId))).go();
    });
  }

  Future<ArquivoVideoDb?> findById(int id) {
    return (select(arquivosVideoDb)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
