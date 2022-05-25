import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/download_prova.table.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:drift/drift.dart';

part 'download_prova.dao.g.dart';

@DriftAccessor(tables: [DownloadProvasDb])
class DownloadProvaDao extends DatabaseAccessor<AppDatabase> with _$DownloadProvaDaoMixin {
  DownloadProvaDao(AppDatabase db) : super(db);

  Future inserir(DownloadProvaDb entity) {
    return into(downloadProvasDb).insert(entity);
  }

  Future inserirOuAtualizar(DownloadProvaDb entity) {
    return into(downloadProvasDb).insertOnConflictUpdate(entity);
  }

  Future remover(DownloadProvaDb entity) {
    return delete(downloadProvasDb).delete(entity);
  }

  Future deleteByProva(int provaId) {
    return (delete(downloadProvasDb)..where((t) => t.provaId.equals(provaId))).go();
  }

  Future<List<DownloadProvaDb>> getByProva(int provaId) {
    return (select(downloadProvasDb)..where((t) => t.provaId.equals(provaId))).get();
  }

  Future<List<DownloadProvaDb>> getByProvaETipo(int provaId, EnumDownloadTipo tipoDownload) {
    return (select(downloadProvasDb)..where((t) => t.provaId.equals(provaId) & t.tipo.equals(tipoDownload.index)))
        .get();
  }

  Future<List<EnumDownloadTipo>> getTiposByProva(int provaId) {
    var query = select(downloadProvasDb)..where((t) => t.provaId.equals(provaId));

    return query.map((p0) => p0.tipo).get();
  }

  Future<List<DownloadProvaDb>> listarTodos() {
    return select(downloadProvasDb).get();
  }

  Future<List<DownloadProvaDb>> obterNaoConcluidos() {
    return (select(downloadProvasDb)
          ..where((t) => t.downloadStatus.isNotIn([
                EnumDownloadStatus.CONCLUIDO.index,
              ]))
          ..orderBy([(t) => OrderingTerm(expression: t.tipo)]))
        .get();
  }

  Future<int> updateStatus(DownloadProvaDb download, EnumDownloadStatus status) async {
    return (update(downloadProvasDb)
          ..where(
            (t) => t.id.equals(download.id) & t.provaId.equals(download.provaId),
          ))
        .write(
      DownloadProvasDbCompanion(
        downloadStatus: Value(status),
      ),
    );
  }
}
