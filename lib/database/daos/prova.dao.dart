import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/prova.table.dart';
import 'package:appserap/database/tables/prova_aluno.table.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:drift/drift.dart';

part 'prova.dao.g.dart';

@DriftAccessor(tables: [ProvasDb, ProvaAlunoTable])
class ProvaDao extends DatabaseAccessor<AppDatabase> with _$ProvaDaoMixin {
  ProvaDao(AppDatabase db) : super(db);

  Future inserir(ProvaDb entity) {
    return into(provasDb).insert(entity);
  }

  Future inserirOuAtualizar(ProvaDb entity) {
    return into(provasDb).insertOnConflictUpdate(entity);
  }

  Future deleteByProva(int provaId) {
    return (delete(provasDb)..where((t) => t.id.equals(provaId))).go();
  }

  Future<List<ProvaDb>> listarTodos() {
    return select(provasDb).get();
  }

  Future<ProvaDb> obterPorProvaId(int provaId) {
    return (select(provasDb)..where((t) => t.id.equals(provaId))).getSingle();
  }

  Future<ProvaDb?> obterPorIdNull(int id) {
    return (select(provasDb)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<int>> obterIds() {
    var query = select(provasDb);
    return query.map((row) => row.id).get();
  }

  Future<List<ProvaDb>> listarTodosPorAluno(String codigoEOL) async {
    final query = select(provasDb).join([
      innerJoin(provaAlunoTable, provaAlunoTable.provaId.equalsExp(provasDb.id)),
    ])
      ..where(provaAlunoTable.codigoEOL.equals(codigoEOL))
      ..orderBy([OrderingTerm.asc(provasDb.dataInicio)]);

    var rows = await query.get();

    return rows.map((resultRow) {
      return resultRow.readTable(provasDb);
    }).toList();
  }

  Future<List<ProvaDb>> obterPendentes() {
    return (select(provasDb)
          ..where(
            (t) => t.status.equals(EnumProvaStatus.PENDENTE.index),
          ))
        .get();
  }

  updateDownloadStatus(int provaId, EnumDownloadStatus status) {
    return (update(provasDb)
          ..where(
            (t) => t.id.equals(provaId),
          ))
        .write(
      ProvasDbCompanion(
        downloadStatus: Value(status),
      ),
    );
  }

  updateDownloadId(int provaId, int downloadId) {
    return (update(provasDb)
          ..where(
            (t) => t.id.equals(provaId),
          ))
        .write(
      ProvasDbCompanion(
        idDownload: Value(downloadId),
      ),
    );
  }
}
