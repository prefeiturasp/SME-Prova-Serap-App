import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/arquivo_audio.table.dart';
import 'package:drift/drift.dart';

part 'arquivo_audio.dao.g.dart';

@DriftAccessor(tables: [ArquivosAudioDb])
class ArquivosAudioDao extends DatabaseAccessor<AppDatabase> with _$ArquivosAudioDaoMixin {
  ArquivosAudioDao(AppDatabase db) : super(db);

  Future inserir(ArquivoAudioDb entity) {
    return into(arquivosAudioDb).insert(entity);
  }

  Future inserirOuAtualizar(ArquivoAudioDb entity) {
    return into(arquivosAudioDb).insertOnConflictUpdate(entity);
  }

  Future remover(ArquivoAudioDb entity) {
    return delete(arquivosAudioDb).delete(entity);
  }

  Future<List<ArquivoAudioDb>> findByProvaId(int provaId) {
    return (select(arquivosAudioDb)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<ArquivoAudioDb?> obterPorQuestaoId(int questaoId) {
    return (select(arquivosAudioDb)..where((t) => t.questaoId.equals(questaoId))).getSingleOrNull();
  }

  Future<List<ArquivoAudioDb>> listarTodos() {
    return select(arquivosAudioDb).get();
  }

  Future<int> removerPorProvaId(int provaId) {
    return transaction(() async {
      return await (delete(arquivosAudioDb)..where((t) => t.provaId.equals(provaId))).go();
    });
  }

  Future<ArquivoAudioDb?> findById(int id) {
    return (select(arquivosAudioDb)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
