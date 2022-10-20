import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/prova_caderno.table.dart';
import 'package:appserap/models/prova_caderno.model.dart';
import 'package:drift/drift.dart';

part 'prova_caderno.dao.g.dart';

@DriftAccessor(tables: [ProvaCadernoTable])
class ProvaCadernoDao extends DatabaseAccessor<AppDatabase> with _$ProvaCadernoDaoMixin {
  ProvaCadernoDao(AppDatabase db) : super(db);

  Future inserir(ProvaCaderno entity) {
    return into(provaCadernoTable).insert(entity);
  }

  Future inserirOuAtualizar(ProvaCaderno entity) {
    return into(provaCadernoTable).insertOnConflictUpdate(entity);
  }

  Future remover(ProvaCaderno entity) {
    return delete(provaCadernoTable).delete(entity);
  }

  Future<List<ProvaCaderno>> listarTodos() {
    return select(provaCadernoTable).get();
  }

  Future<List<ProvaCaderno>> getByProvaId(int provaId) {
    return (select(provaCadernoTable)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<int> removerPorProvaId(int provaId) {
    return transaction(() {
      return (delete(provaCadernoTable)..where((t) => t.provaId.equals(provaId))).go();
    });
  }

  Future<ProvaCaderno> findByQuestaoId(int questaoId, int provaId, String caderno) {
    return (select(provaCadernoTable)
          ..where((t) => t.questaoId.equals(questaoId) & t.provaId.equals(provaId) & t.caderno.equals(caderno)))
        .getSingle();
  }

  Future<ProvaCaderno> obterPorProvaECaderno(int idProva, String caderno) {
    return (select(provaCadernoTable)..where((t) => t.provaId.equals(idProva) & t.caderno.equals(caderno))).getSingle();
  }

  Future<int> obterQuestaoIdPorProvaECadernoEOrdem(int idProva, String caderno, int ordem) async {
    var questao = await (select(provaCadernoTable)
          ..where((t) => t.provaId.equals(idProva) & t.caderno.equals(caderno) & t.ordem.equals(ordem)))
        .getSingle();

    return questao.questaoId;
  }

  Future<int> obterQuestaoIdPorProvaECadernoEQuestao(int idProva, String caderno, int questaoLegadoId) async {
    var questao = await (select(provaCadernoTable)
          ..where(
              (t) => t.provaId.equals(idProva) & t.caderno.equals(caderno) & t.questaoLegadoId.equals(questaoLegadoId)))
        .getSingle();

    return questao.questaoId;
  }
}
