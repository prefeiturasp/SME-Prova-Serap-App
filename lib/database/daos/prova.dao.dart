import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:drift/drift.dart';

part 'prova.dao.g.dart';

@DriftAccessor(tables: [ProvasDb])
class ProvaDAO extends DatabaseAccessor<AppDatabase> with _$ProvaDAOMixin {
  ProvaDAO(AppDatabase db) : super(db);

  Future inserir(ProvaDb entity) {
    return into(provasDb).insert(entity);
  }

  Future inserirOuAtualizar(ProvaDb entity) {
    return into(provasDb).insertOnConflictUpdate(entity);
  }

  Future deleteByProva(int provaId) {
    return (delete(provasDb)..where((t) => t.id.equals(provaId))).go();
  }

  Future<List<ProvaDb>> obterPorProvaId(int provaId) {
    return (select(provasDb)..where((t) => t.id.equals(provaId))).get();
  }

  Future<List<ProvaDb>> listarTodos() {
    return select(provasDb).get();
  }

  Future<List<int>> obterProvasCacheIds() {
    var query = select(provasDb);
    return query.map((row) => row.id).get();
  }

  Future<List<ProvaDb>> obterProvasPendentes() {
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
