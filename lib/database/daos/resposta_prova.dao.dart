import 'package:appserap/database/app.database.dart';
import 'package:appserap/models/resposta_prova.model.dart';
import 'package:drift/drift.dart';

part 'resposta_prova.dao.g.dart';

@DriftAccessor(tables: [RespostaProvaTable])
class RespostaProvaDAO extends DatabaseAccessor<AppDatabase> with _$RespostaProvaDAOMixin {
  RespostaProvaDAO(AppDatabase db) : super(db);

  Future inserir(RespostaProva entity) {
    return into(respostaProvaTable).insert(entity);
  }

  Future inserirOuAtualizar(RespostaProva entity) {
    return into(respostaProvaTable).insertOnConflictUpdate(entity);
  }

  Future remover(RespostaProva entity) {
    return delete(respostaProvaTable).delete(entity);
  }

  Future<List<RespostaProva>> obterPorProvaId(int provaId) {
    return (select(respostaProvaTable)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<List<RespostaProva>> obterPorProvaIdECodigoEOL(int provaId, String codigoEOL) {
    return (select(respostaProvaTable)..where((t) => t.provaId.equals(provaId) & t.codigoEOL.equals(codigoEOL))).get();
  }

  Future<RespostaProva?> obterPorQuestaoId(int questaoId) {
    return (select(respostaProvaTable)..where((t) => t.questaoId.equals(questaoId))).getSingleOrNull();
  }

  Future<List<RespostaProva>> obterTodasNaoSincronizadas() {
    return (select(respostaProvaTable)..where((t) => t.sincronizado.not())).get();
  }

  Future<List<RespostaProva>> obterTodasNaoSincronizadasPorCodigoEProva(String codigoEOL, int provaId) {
    return (select(respostaProvaTable)
          ..where((t) => t.codigoEOL.equals(codigoEOL) & t.provaId.equals(provaId) & t.sincronizado.not()))
        .get();
  }

  Future<List<RespostaProva>> obterNaoSincronizadasPorProva(int provaId) {
    return (select(respostaProvaTable)..where((t) => t.provaId.equals(provaId) & t.sincronizado.not())).get();
  }

  Future<Future<int>> definirSincronizado(RespostaProva resposta, bool sincronizado) async {
    return (update(respostaProvaTable)
          ..where(
            (t) =>
                t.codigoEOL.equals(resposta.codigoEOL) &
                t.provaId.equals(resposta.provaId) &
                t.questaoId.equals(resposta.questaoId),
          ))
        .write(
      RespostaProvaTableCompanion(
        sincronizado: Value(sincronizado),
      ),
    );
  }

  Future<List<RespostaProva>> listarTodos() {
    return select(respostaProvaTable).get();
  }

  Future<int> removerPorProvaId(int provaId) {
    return (delete(respostaProvaTable)..where((t) => t.provaId.equals(provaId))).go();
  }

  Future<int> removerSincronizadasPorProva(int provaId) {
    return (delete(respostaProvaTable)..where((t) => t.provaId.equals(provaId) & t.sincronizado)).go();
  }

  Future<int> removerSincronizadas() {
    return (delete(respostaProvaTable)..where((t) => t.sincronizado)).go();
  }
}
