import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/prova_aluno.table.dart';
import 'package:appserap/models/prova_aluno.model.dart';
import 'package:drift/drift.dart';

part 'prova_aluno.dao.g.dart';

@DriftAccessor(tables: [ProvaAlunoTable])
class ProvaAlunoDao extends DatabaseAccessor<AppDatabase> with _$ProvaAlunoDaoMixin {
  ProvaAlunoDao(AppDatabase db) : super(db);

  Future inserir(ProvaAluno entity) {
    return into(provaAlunoTable).insert(entity);
  }

  Future inserirOuAtualizar(ProvaAluno entity) {
    return into(provaAlunoTable).insertOnConflictUpdate(entity);
  }

  Future remover(ProvaAluno entity) {
    return delete(provaAlunoTable).delete(entity);
  }

  Future<List<ProvaAluno>> listarTodos() {
    return select(provaAlunoTable).get();
  }

  Future<List<ProvaAluno>> getByCodigoEOL(String codigoEOL) {
    return (select(provaAlunoTable)..where((t) => t.codigoEOL.equals(codigoEOL))).get();
  }

  Future<List<ProvaAluno>> getByProvaId(int provaId) {
    return (select(provaAlunoTable)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<int> apagarPorUsuario(String codigoEOL) {
    return (delete(provaAlunoTable)..where((t) => t.codigoEOL.equals(codigoEOL))).go();
  }

  Future<int> removerPorProvaId(int provaId) {
    return transaction(() {
      return (delete(provaAlunoTable)..where((t) => t.provaId.equals(provaId))).go();
    });
  }
}
