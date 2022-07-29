import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/alternativa.table.dart';
import 'package:appserap/database/tables/questao.table.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:drift/drift.dart';

part 'questao.dao.g.dart';

@DriftAccessor(tables: [QuestoesDb, AlternativasDb])
class QuestaoDao extends DatabaseAccessor<AppDatabase> with _$QuestaoDaoMixin {
  QuestaoDao(AppDatabase db) : super(db);

  Future inserir(Questao entity) {
    return into(questoesDb).insert(entity);
  }

  Future inserirOuAtualizar(Questao entity) {
    return into(questoesDb).insertOnConflictUpdate(entity);
  }

  Future remover(Questao entity) {
    return delete(questoesDb).delete(entity);
  }

  Future<List<Questao>> obterPorProvaId(int provaId, String caderno) {
    return (select(questoesDb)..where((t) => t.provaId.equals(provaId) & t.caderno.equals(caderno))).get();
  }

  Future<List<Questao>> listarTodos() {
    return select(questoesDb).get();
  }

  Future<List<Questao>> obterQuestoesPorProvaId(int provaId) {
    return (select(questoesDb)
          ..where((t) => t.provaId.equals(provaId))
          ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
        .get();
  }

  Future<int> removerPorProvaId(int id) {
    return transaction(() async {
      return await customUpdate("delete from questoes_db where prova_id = ?", variables: [Variable.withInt(id)]);
    });
  }

  Future<Questao> getByProvaEOrdem(int provaId, int ordem, String caderno) {
    return (select(questoesDb)
          ..where((t) => t.provaId.equals(provaId) & t.ordem.equals(ordem) & t.caderno.equals(caderno)))
        .getSingle();
  }
}
