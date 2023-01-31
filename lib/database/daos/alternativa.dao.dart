import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/alternativa.table.dart';
import 'package:appserap/database/tables/prova_questao_alternativa.table.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:drift/drift.dart';

part 'alternativa.dao.g.dart';

@DriftAccessor(tables: [AlternativasDb, ProvaQuestaoAlternativaTable])
class AlternativaDao extends DatabaseAccessor<AppDatabase> with _$AlternativaDaoMixin {
  AlternativaDao(AppDatabase db) : super(db);

  Future inserir(Alternativa entity) {
    return into(alternativasDb).insert(entity);
  }

  Future inserirOuAtualizar(Alternativa entity) {
    return into(alternativasDb).insertOnConflictUpdate(entity);
  }

  Future remover(Alternativa entity) {
    return delete(alternativasDb).delete(entity);
  }

  Future<List<Alternativa>> obterPorQuestaoLegadoId(int questaoLegadoId) {
    return (select(alternativasDb)..where((t) => t.questaoLegadoId.equals(questaoLegadoId))).get();
  }

  Future<List<Alternativa>> listarTodos() {
    return select(alternativasDb).get();
  }

  Future<int> removerPorQuestaoLegadoId(int questaoLegadoId) {
    return transaction(() async {
      return await (delete(alternativasDb)..where((t) => t.questaoLegadoId.equals(questaoLegadoId))).go();
    });
  }
}
