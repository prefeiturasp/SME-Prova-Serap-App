import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/arquivo.table.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:drift/drift.dart';

part 'arquivo.dao.g.dart';

@DriftAccessor(tables: [ArquivosDb])
class ArquivoDao extends DatabaseAccessor<AppDatabase> with _$ArquivoDaoMixin {
  ArquivoDao(AppDatabase db) : super(db);

  Future inserir(Arquivo entity) {
    return into(arquivosDb).insert(entity);
  }

  Future inserirOuAtualizar(Arquivo entity) {
    return into(arquivosDb).insertOnConflictUpdate(entity);
  }

  Future remover(Arquivo entity) {
    return delete(arquivosDb).delete(entity);
  }

  Future<List<Arquivo>> findByProvaId(int provaId) {
    return (select(arquivosDb)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<List<Arquivo>> obterPorQuestaoId(int questaoId) {
    return (select(arquivosDb)..where((t) => t.questaoId.equals(questaoId))).get();
  }

  Future<List<Arquivo>> listarTodos() {
    return select(arquivosDb).get();
  }

  Future<int> removerPorProvaId(int id) {
    return transaction(() async {
      return await customUpdate("delete from arquivos_db where prova_id = ?", variables: [Variable.withInt(id)]);
    });
  }

  Future<Arquivo?> findByLegadoId(int legadoId) {
    return (select(arquivosDb)..where((t) => t.legadoId.equals(legadoId))).getSingleOrNull();
  }
}
