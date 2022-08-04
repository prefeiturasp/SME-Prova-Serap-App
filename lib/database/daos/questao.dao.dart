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

  Future<Questao?> getById(int id) {
    return (select(questoesDb)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Questao>> obterPorProvaId(int provaId, String caderno) async {
    var query = select(questoesDb).join([
      innerJoin(provaCadernoTable, provaCadernoTable.questaoLegadId.equalsExp(questoesDb.id)),
    ]);

    query.where(provaCadernoTable.provaId.equals(provaId) & provaCadernoTable.caderno.equals(caderno));

    query.orderBy([OrderingTerm.asc(provaCadernoTable.ordem)]);

    var rows = await query.get();

    return rows.map((resultRow) {
      return resultRow.readTable(questoesDb);
    }).toList();
  }

  Future<int> removerPorProvaId(int provaId) async {
    var query = select(questoesDb).join([
      innerJoin(provaCadernoTable, provaCadernoTable.questaoLegadId.equalsExp(questoesDb.id)),
    ]);

    query.where(provaCadernoTable.provaId.equals(provaId));

    var rows = await query.get();

    var questoesId = rows.map((resultRow) {
      return resultRow.read(questoesDb.id);
    }).toList();

    return (delete(questoesDb)..where((t) => t.id.isIn(questoesId))).go();
  }

  Future<Questao> getByProvaEOrdem(int provaId, String caderno, int ordem) async {
    var query = select(questoesDb).join([
      innerJoin(provaCadernoTable, provaCadernoTable.questaoLegadId.equalsExp(questoesDb.id)),
    ]);

    query.where(provaCadernoTable.provaId.equals(provaId) &
        provaCadernoTable.caderno.equals(caderno) &
        provaCadernoTable.ordem.equals(ordem));

    var row = await query.getSingle();

    return row.readTable(questoesDb);
  }
}
