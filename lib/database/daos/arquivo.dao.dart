import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';

part 'arquivo.dao.g.dart';

@DriftAccessor(tables: [ArquivosDb])
class ArquivoDAO extends DatabaseAccessor<AppDatabase> with _$ArquivoDAOMixin {
  ArquivoDAO(AppDatabase db) : super(db);

  Future inserir(ArquivoDb entity) {
    return into(arquivosDb).insert(entity);
  }

  Future inserirOuAtualizar(ArquivoDb entity) {
    return into(arquivosDb).insertOnConflictUpdate(entity);
  }

  Future remover(ArquivoDb entity) {
    return delete(arquivosDb).delete(entity);
  }

  Future<List<ArquivoDb>> obterPorProvaId(int provaId) {
    return (select(arquivosDb)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<List<ArquivoDb>> listarTodos() {
    return select(arquivosDb).get();
  }

  Future removerArquivosPorProvaId(int id) {
    return transaction(() async {
      await customUpdate("delete from arquivos_db where prova_id = ?", variables: [Variable.withInt(id)]);
    });
  }
}
