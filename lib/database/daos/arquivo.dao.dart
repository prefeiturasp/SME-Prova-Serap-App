import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/arquivo.table.dart';
import 'package:appserap/database/tables/prova_caderno.table.dart';
import 'package:appserap/database/tables/questao_arquivo.table.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:drift/drift.dart';

part 'arquivo.dao.g.dart';

@DriftAccessor(tables: [ArquivosDb, QuestaoArquivoTable, ProvaCadernoTable])
class ArquivoDao extends DatabaseAccessor<AppDatabase> with _$ArquivoDaoMixin {
  ArquivoDao(AppDatabase db) : super(db);

  Future inserir(Arquivo entity) {
    return into(arquivosDb).insert(entity);
  }

  Future<int> inserirOuAtualizar(Arquivo entity) {
    return into(arquivosDb).insertOnConflictUpdate(entity);
  }

  Future remover(Arquivo entity) {
    return delete(arquivosDb).delete(entity);
  }

  // Future<List<Arquivo>> findByProvaId(int provaId) {
  //   return (select(arquivosDb)..where((t) => t.provaId.equals(provaId))).get();
  // }

  Future<List<Arquivo>> obterPorQuestaoLegadoId(int questaoLegadoId) async {
    final query = select(arquivosDb).join([
      innerJoin(questaoArquivoTable, questaoArquivoTable.arquivoLegadoId.equalsExp(arquivosDb.legadoId)),
    ])
      ..where(questaoArquivoTable.questaoLegadoId.equals(questaoLegadoId));

    var rows = await query.get();

    return rows.map((resultRow) {
      return resultRow.readTable(arquivosDb);
    }).toList();
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

  Future<List<Arquivo>> findByProvaECaderno(int provaId, String caderno) async {
    final query = select(arquivosDb).join([
      innerJoin(questaoArquivoTable, questaoArquivoTable.arquivoLegadoId.equalsExp(arquivosDb.legadoId)),
      innerJoin(provaCadernoTable, provaCadernoTable.questaoLegadoId.equalsExp(questaoArquivoTable.questaoLegadoId)),
    ])
      ..where(provaCadernoTable.provaId.equals(provaId) & provaCadernoTable.caderno.equals(caderno));

    var rows = await query.get();

    return rows.map((resultRow) {
      return resultRow.readTable(arquivosDb);
    }).toList();
  }
}
