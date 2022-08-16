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

  Future<ArquivoAudioDb?> obterPorQuestaoLegadoId(int questaoLegadoId) {
    return (select(arquivosAudioDb)..where((t) => t.questaoLegadoId.equals(questaoLegadoId))).getSingleOrNull();
  }

  Future<List<ArquivoAudioDb>> listarTodos() {
    return select(arquivosAudioDb).get();
  }

  Future<ArquivoAudioDb?> findById(int id) {
    return (select(arquivosAudioDb)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<ArquivoAudioDb?> findByQuestaoLegadoId(int questaoLegadoId) {
    return (select(arquivosAudioDb)..where((t) => t.questaoLegadoId.equals(questaoLegadoId))).getSingleOrNull();
  }
}
