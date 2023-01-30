import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/prova_questao_alternativa.table.dart';
import 'package:appserap/models/prova_questao_alternativa.model.dart';
import 'package:drift/drift.dart';

part 'prova_questao_alternativa.dao.g.dart';

@DriftAccessor(tables: [ProvaQuestaoAlternativaTable])
class ProvaQuestaoAlternativaDao extends DatabaseAccessor<AppDatabase> with _$ProvaQuestaoAlternativaDaoMixin {
  ProvaQuestaoAlternativaDao(AppDatabase db) : super(db);

  Future inserir(ProvaQuestaoAlternativa entity) {
    return into(provaQuestaoAlternativaTable).insert(entity);
  }

  Future inserirOuAtualizar(ProvaQuestaoAlternativa entity) {
    return into(provaQuestaoAlternativaTable).insertOnConflictUpdate(entity);
  }

  Future remover(ProvaQuestaoAlternativa entity) {
    return delete(provaQuestaoAlternativaTable).delete(entity);
  }

  Future<List<ProvaQuestaoAlternativa>> listarTodos() {
    return select(provaQuestaoAlternativaTable).get();
  }

  Future<List<ProvaQuestaoAlternativa>> getByProvaId(int provaId) {
    return (select(provaQuestaoAlternativaTable)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<int> removerPorProvaId(int provaId) {
    return transaction(() {
      return (delete(provaQuestaoAlternativaTable)..where((t) => t.provaId.equals(provaId))).go();
    });
  }

  Future<ProvaQuestaoAlternativa> findByQuestaoId(int questaoId, int provaId, String caderno) {
    return (select(provaQuestaoAlternativaTable)
          ..where((t) => t.questaoId.equals(questaoId) & t.provaId.equals(provaId) & t.caderno.equals(caderno)))
        .getSingle();
  }

  Future<ProvaQuestaoAlternativa> obterPorProvaECaderno(int idProva, String caderno) {
    return (select(provaQuestaoAlternativaTable)..where((t) => t.provaId.equals(idProva) & t.caderno.equals(caderno)))
        .getSingle();
  }

  Future<int> obterQuestaoIdPorProvaECadernoEOrdem(int idProva, String caderno, int ordem) async {
    var questao = await (select(provaQuestaoAlternativaTable)
          ..where((t) => t.provaId.equals(idProva) & t.caderno.equals(caderno) & t.ordem.equals(ordem)))
        .getSingle();

    return questao.questaoId;
  }

  Future<int> obterQuestaoIdPorProvaECadernoEQuestao(int idProva, String caderno, int questaoLegadoId) async {
    var questao = await (select(provaQuestaoAlternativaTable)
          ..where(
              (t) => t.provaId.equals(idProva) & t.caderno.equals(caderno) & t.questaoLegadoId.equals(questaoLegadoId)))
        .getSingle();

    return questao.questaoId;
  }

  Future<ProvaQuestaoAlternativa> obterAlternativaPorProvaECadernoEQuestao(int idProva, String caderno, int questaoId, int alternativaLegadoId) async {
    var questao = await (select(provaQuestaoAlternativaTable)
      ..where(
              (t) => t.provaId.equals(idProva) & t.caderno.equals(caderno) & t.questaoId.equals(questaoId) & t.alternativaLegadoId.equals(alternativaLegadoId)))
        .getSingle();

    return questao;
  }
}
