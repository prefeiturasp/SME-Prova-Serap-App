import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/alternativa.table.dart';
import 'package:appserap/database/tables/prova_caderno.table.dart';
import 'package:appserap/database/tables/questao.table.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:drift/drift.dart';

part 'questao.dao.g.dart';

@DriftAccessor(tables: [QuestoesDb, AlternativasDb, ProvaCadernoTable])
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

  Future<List<Questao>> listarTodos() {
    return select(questoesDb).get();
  }

  Future<Questao?> getByQuestaoId(int questaoId) async {
    var query = select(questoesDb).join([
      innerJoin(provaCadernoTable, provaCadernoTable.questaoLegadoId.equalsExp(questoesDb.questaoLegadoId)),
    ]);

    query.where(provaCadernoTable.questaoId.equals(questaoId));

    var rows = await query.get();

    if (rows.isNotEmpty) {
      return rows.first.readTable(questoesDb);
    }
  }

  Future<List<Questao>> obterPorProvaECaderno(int provaId, String caderno) async {
    var query = select(questoesDb).join([
      innerJoin(provaCadernoTable, provaCadernoTable.questaoLegadoId.equalsExp(questoesDb.questaoLegadoId)),
    ]);

    query.where(provaCadernoTable.provaId.equals(provaId) & provaCadernoTable.caderno.equals(caderno));

    query.orderBy([OrderingTerm.asc(provaCadernoTable.ordem)]);

    var rows = await query.get();

    return rows.map((resultRow) {
      return resultRow.readTable(questoesDb);
    }).toList();
  }

  Future<List<Questao>> obterPorProvaId(int provaId) async {
    var query = select(questoesDb).join([
      innerJoin(provaCadernoTable, provaCadernoTable.questaoLegadoId.equalsExp(questoesDb.questaoLegadoId)),
    ]);
    query.where(provaCadernoTable.provaId.equals(provaId));

    var rows = await query.get();

    return rows.map((resultRow) {
      return resultRow.readTable(questoesDb);
    }).toList();
  }

  Future<int> removerPorProvaId(int provaId) async {
    var query = select(questoesDb).join([
      innerJoin(provaCadernoTable, provaCadernoTable.questaoLegadoId.equalsExp(questoesDb.questaoLegadoId)),
    ]);

    query.where(provaCadernoTable.provaId.equals(provaId));

    var rows = await query.get();

    var questoesLegadoId = rows.map((resultRow) {
      return resultRow.read(questoesDb.questaoLegadoId)!;
    }).toList();

    return (delete(questoesDb)..where((t) => t.questaoLegadoId.isIn(questoesLegadoId))).go();
  }

  Future<Questao> getByProvaEOrdem(int provaId, String caderno, int ordem) async {
    var query = select(questoesDb).join([
      innerJoin(provaCadernoTable, provaCadernoTable.questaoLegadoId.equalsExp(questoesDb.questaoLegadoId)),
    ]);

    query.where(provaCadernoTable.provaId.equals(provaId) &
        provaCadernoTable.caderno.equals(caderno) &
        provaCadernoTable.ordem.equals(ordem));

    var row = await query.getSingle();

    return row.readTable(questoesDb);
  }

  Future<Questao?> getByQuestaoLegadoId(int questaoLegadoId) {
    return (select(questoesDb)..where((t) => t.questaoLegadoId.equals(questaoLegadoId))).getSingleOrNull();
  }

  Future<List<Questao>> getByQuestaoLegadoIds(List<int> legadoIds) async {
    return (select(questoesDb)..where((t) => t.questaoLegadoId.isIn(legadoIds))).get();
  }
}
