import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';

part 'questao.dao.g.dart';

@DriftAccessor(tables: [QuestoesDb, AlternativasDb])
class QuestaoDAO extends DatabaseAccessor<AppDatabase> with _$QuestaoDAOMixin {
  QuestaoDAO(AppDatabase db) : super(db);

  Future inserir(QuestaoDb entity) {
    return into(questoesDb).insert(entity);
  }

  Future inserirOuAtualizar(QuestaoDb entity) {
    return into(questoesDb).insertOnConflictUpdate(entity);
  }

  Future remover(QuestaoDb entity) {
    return delete(questoesDb).delete(entity);
  }

  Future<List<QuestaoDb>> obterPorProvaId(int provaId) {
    return (select(questoesDb)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<List<QuestaoDb>> listarTodos() {
    return select(questoesDb).get();
  }

  Future<QuestaoDb?> obterQuestaoPorArquivoLegadoId(int arquivoLegadoId, int provaId) {
    return customSelect('''
        select * from questoes_db 
        where (titulo like '%$arquivoLegadoId%' or descricao like '%$arquivoLegadoId%') and prova_id = $provaId limit 1
        ''', readsFrom: {
      questoesDb,
    }).map(questoesDb.mapFromRow).getSingleOrNull();
  }

  Future<QuestaoDb?> obterQuestaoPorArquivoLegadoIdAlternativa(int arquivoLegadoId, int provaId) {
    return customSelect(
      '''
        select distinct questoes_db.* from questoes_db
          inner join alternativas_db on questoes_db.id = alternativas_db.questao_id and questoes_db.prova_id = alternativas_db.prova_id
        where alternativas_db.descricao like '%$arquivoLegadoId%' 
          and alternativas_db.prova_id = $provaId 
        limit 1
        ''',
      readsFrom: {questoesDb, alternativasDb},
    ).map(questoesDb.mapFromRow).getSingleOrNull();
  }

  Future<List<QuestaoDb>> obterQuestoesPorProvaId(int provaId) {
    return (select(questoesDb)
          ..where((t) => t.provaId.equals(provaId))
          ..orderBy([(t) => OrderingTerm(expression: t.ordem)]))
        .get();
  }

  Future removerQuestoesPorProvaId(int id) {
    return transaction(() async {
      await customUpdate("delete from questoes_db where prova_id = ?", variables: [Variable.withInt(id)]);
    });
  }
}
