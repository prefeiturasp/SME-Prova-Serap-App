import 'dart:async';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/tables/prova.table.dart';
import 'package:appserap/database/tables/prova_aluno.table.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:drift/drift.dart';

part 'prova.dao.g.dart';

@DriftAccessor(tables: [ProvasDb, ProvaAlunoTable])
class ProvaDao extends DatabaseAccessor<AppDatabase> with _$ProvaDaoMixin {
  ProvaDao(AppDatabase db) : super(db);

  Future inserir(Prova entity) {
    return into(provasDb).insert(entity);
  }

  Future inserirOuAtualizar(Prova entity) {
    return into(provasDb).insertOnConflictUpdate(entity);
  }

  Future<int> deleteByProva(int provaId) {
    return transaction(() => (delete(provasDb)..where((t) => t.id.equals(provaId))).go());
  }

  Future<Prova?> existeProva(int provaId, String caderno) {
    var query = select(provasDb);

    query.where((t) => t.id.equals(provaId) & t.caderno.equals(caderno));

    return query.getSingleOrNull();
  }

  Future<List<Prova>> listarTodos() {
    return select(provasDb).get();
  }

  Future<Prova> obterPorProvaIdECaderno(int provaId, String caderno) {
    return (select(provasDb)..where((t) => t.id.equals(provaId) & t.caderno.equals(caderno))).getSingle();
  }

  Future<Prova> obterPorProvaId(int provaId) {
    return (select(provasDb)..where((t) => t.id.equals(provaId))).getSingle();
  }

  Future<Prova?> obterPorIdNull(int id, String caderno) {
    return (select(provasDb)..where((t) => t.id.equals(id) & t.caderno.equals(caderno))).getSingleOrNull();
  }

  Future<List<int>> obterIds() {
    var query = select(provasDb);
    return query.map((row) => row.id).get();
  }

  Future<List<Prova>> listarTodosPorAluno(String codigoEOL) async {
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

  Future<List<Prova>> obterPendentes() {
    return (select(provasDb)
          ..where(
            (t) => t.status.equals(EnumProvaStatus.PENDENTE.index),
          ))
        .get();
  }

  Future<int> updateDownloadStatus(int provaId, String caderno, EnumDownloadStatus status) {
    return (update(provasDb)
          ..where(
            (t) => t.id.equals(provaId) & t.caderno.equals(caderno),
          ))
        .write(
      ProvasDbCompanion(
        downloadStatus: Value(status),
      ),
    );
  }

  Future<int> updateDownloadId(int provaId, String caderno, String downloadId) {
    return (update(provasDb)
          ..where(
            (t) => t.id.equals(provaId) & t.caderno.equals(caderno),
          ))
        .write(
      ProvasDbCompanion(
        idDownload: Value(downloadId),
      ),
    );
  }

  Future<int> atualizarStatus(int provaId, String caderno, EnumProvaStatus status) {
    return (update(provasDb)
          ..where(
            (t) => t.id.equals(provaId) & t.caderno.equals(caderno),
          ))
        .write(
      ProvasDbCompanion(
        status: Value(status),
      ),
    );
  }

  Future<int> atualizaDataFimProvaAluno(int provaId, String caderno, DateTime dataFimProvaAluno) {
    return (update(provasDb)
          ..where(
            (t) => t.id.equals(provaId) & t.caderno.equals(caderno),
          ))
        .write(
      ProvasDbCompanion(
        dataFimProvaAluno: Value(dataFimProvaAluno),
      ),
    );
  }

  Future<int> atualizaDataInicioProvaAluno(int provaId, String caderno, DateTime dataInicioProvaAluno) {
    return (update(provasDb)
          ..where(
            (t) => t.id.equals(provaId) & t.caderno.equals(caderno),
          ))
        .write(
      ProvasDbCompanion(
        dataInicioProvaAluno: Value(dataInicioProvaAluno),
      ),
    );
  }

  Future<List<Prova>> getProvasExpiradas() {
    var query = select(provasDb)
      ..where((t) {
        var hoje = DateTime.now();

        var fimExpirado = t.dataFim.isSmallerThanValue(DateTime(hoje.year, hoje.month, hoje.day));
        var status = t.status.isNotIn([
          EnumProvaStatus.FINALIZADA.index,
          EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE_JOB.index,
          EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE_TEMPO.index,
          EnumProvaStatus.FINALIZADA_OFFLINE.index,
        ]);

        return fimExpirado & status;
      });

    return query.get();
  }
}
