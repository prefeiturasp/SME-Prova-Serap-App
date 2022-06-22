import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/contexto_prova.table.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:drift/drift.dart';

part 'contexto_prova.dao.g.dart';

@DriftAccessor(tables: [ContextosProvaDb])
class ContextoProvaDao extends DatabaseAccessor<AppDatabase> with _$ContextoProvaDaoMixin {
  ContextoProvaDao(AppDatabase db) : super(db);

  Future inserir(ContextoProva entity) {
    return into(contextosProvaDb).insert(entity);
  }

  Future inserirOuAtualizar(ContextoProva entity) {
    return into(contextosProvaDb).insertOnConflictUpdate(entity);
  }

  Future remover(ContextoProva entity) {
    return delete(contextosProvaDb).delete(entity);
  }

  Future<List<ContextoProva>> obterPorProvaId(int provaId) {
    return (select(contextosProvaDb)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<List<ContextoProva>> listarTodos() {
    return select(contextosProvaDb).get();
  }

  Future<bool> possuiContexto(int provaId) async {
    final query = select(contextosProvaDb)..where((t) => t.provaId.isIn([provaId]));

    return (await query.get()).isNotEmpty;
  }

  Future removerContextoPorProvaId(int id) {
    return transaction(() async {
      await customUpdate("delete from contextos_prova_db where prova_id = ?", variables: [Variable.withInt(id)]);
    });
  }
}
