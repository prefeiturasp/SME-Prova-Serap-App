import 'package:appserap/database/daos/arquivo_video.dao.dart';
import 'package:appserap/database/daos/download_prova.dao.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/enums/job_status.enum.dart';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'package:appserap/models/prova_aluno.model.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/prova_caderno.model.dart';
import 'package:appserap/models/questao_arquivo.model.dart';
import 'package:appserap/models/job.model.dart';

import 'daos/alternativa.dao.dart';
import 'daos/arquivo.dao.dart';
import 'daos/arquivo_audio.dao.dart';
import 'daos/contexto_prova.dao.dart';
import 'daos/jobs.dao.dart';
import 'daos/prova.dao.dart';
import 'daos/prova_aluno.dao.dart';
import 'daos/prova_caderno.dao.dart';
import 'daos/questao.dao.dart';
import 'daos/questao_arquivo.dao.dart';
import 'tables/alternativa.table.dart';
import 'tables/arquivo.table.dart';
import 'tables/arquivo_audio.table.dart';
import 'tables/arquivo_video.table.dart';
import 'tables/contexto_prova.table.dart';
import 'tables/download_prova.table.dart';
import 'tables/jobs.table.dart';
import 'tables/prova.table.dart';
import 'tables/prova_aluno.table.dart';
import 'tables/prova_caderno.table.dart';
import 'tables/questao.table.dart';
import 'tables/questao_arquivo.table.dart';

import 'core/shared.database.dart' as impl;

export 'core/shared.database.dart';

part 'app.database.g.dart';

@DriftDatabase(
  tables: [
    ProvasDb,
    QuestoesDb,
    AlternativasDb,
    ArquivosDb,
    ContextosProvaDb,
    ArquivosVideoDb,
    ArquivosAudioDb,
    DownloadProvasDb,
    ProvaAlunoTable,
    ProvaCadernoTable,
    QuestaoArquivoTable,
    JobsTable,
  ],
  daos: [
    ArquivosVideosDao,
    ArquivosAudioDao,
    DownloadProvaDao,
    QuestaoDao,
    AlternativaDao,
    ArquivoDao,
    ContextoProvaDao,
    ProvaDao,
    ProvaAlunoDao,
    ProvaCadernoDao,
    QuestaoArquivoDao,
    JobDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super.connect(impl.connect()) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  }

  AppDatabase.executor(QueryExecutor e) : super(e);

  AppDatabase.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 24;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        await transaction(() async {
          // put your migration logic here

          if (from < 2) {
            await m.addColumn(provasDb, provasDb.senha);
          }
          if (from < 3) {
            await m.addColumn(questoesDb, questoesDb.quantidadeAlternativas);
          }

          if (from < 4) {
            await m.createTable(contextosProvaDb);
          }

          if (from < 5) {
            await m.addColumn(arquivosDb, arquivosDb.legadoId);
          }

          if (from < 6) {
            await m.addColumn(provasDb, provasDb.idDownload);
          }

          if (from < 7) {
            await m.createTable(arquivosVideoDb);
          }

          if (from < 8) {
            await m.createTable(arquivosAudioDb);
          }

          if (from < 9) {
            await m.addColumn(provasDb, provasDb.quantidadeRespostaSincronizacao);
          }

          if (from < 10) {
            await m.createTable(downloadProvasDb);
          }

          if (from < 12) {
            await m.addColumn(provasDb, provasDb.ultimaAlteracao);
          }

          if (from < 13) {
            await m.createTable(provaAlunoTable);
          }

          if (from < 14) {
            await m.alterTable(
              TableMigration(provasDb, columnTransformer: {
                provasDb.idDownload: provasDb.idDownload.cast<String>(),
              }),
            );
          }

          if (from < 15) {
            await m.alterTable(TableMigration(questoesDb));
          }

          if (from < 17) {
            await m.alterTable(TableMigration(arquivosDb));
            await m.alterTable(TableMigration(contextosProvaDb));
          }

          if (from < 18) {
            await m.addColumn(provasDb, provasDb.caderno);
          }

          if (from < 20) {
            await m.create(provaCadernoTable);
            await m.create(questaoArquivoTable);

            await m.drop(provasDb);
            await m.create(provasDb);

            await m.drop(questoesDb);
            await m.create(questoesDb);

            await m.drop(alternativasDb);
            await m.create(alternativasDb);

            await m.drop(arquivosVideoDb);
            await m.create(arquivosVideoDb);

            await m.drop(arquivosAudioDb);
            await m.create(arquivosAudioDb);

            await m.drop(downloadProvasDb);
            await m.create(downloadProvasDb);

            await m.alterTable(TableMigration(arquivosDb));
          }

          if (from < 21) {
            await m.createTable(jobsTable);
          }

          if (from < 22) {
            await m.alterTable(TableMigration(provasDb));
          }

          if (from < 23) {
            await m.addColumn(provasDb, provasDb.provaComProficiencia);
            await m.addColumn(provasDb, provasDb.apresentarResultados);
            await m.addColumn(provasDb, provasDb.apresentarResultadosPorItem);
          }

          if (from < 24) {
            await m.addColumn(provasDb, provasDb.formatoTai);
            await m.addColumn(provasDb, provasDb.formatoTaiItem);
            await m.addColumn(provasDb, provasDb.formatoTaiAvancarSemResponder);
            await m.addColumn(provasDb, provasDb.formatoTaiVoltarItemAnterior);
          }
        });

        // Assert that the schema is valid after migrations
        if (kDebugMode) {
          final wrongForeignKeys = await customSelect('PRAGMA foreign_key_check').get();
          assert(wrongForeignKeys.isEmpty, '${wrongForeignKeys.map((e) => e.data)}');
        }
      }, beforeOpen: (details) async {
        await customStatement('PRAGMA auto_vacuum = FULL;');
        await customStatement('PRAGMA foreign_keys = ON;');
      });

  Future limpar() {
    return transaction(() async {
      // await customUpdate("delete from alternativas_db;");

      // await customUpdate("delete from questoes_db;");

      // await customUpdate("delete from arquivos_db;");

      // await customUpdate("delete from contextos_prova_db;");

      // await customUpdate("delete from arquivos_video_db;");
      // await customUpdate("delete from arquivos_audio_db;");

      // await customUpdate("delete from provas_db;");

      await customUpdate("delete from download_provas_db;");
    });
  }

  Future limparBanco() {
    return transaction(() async {
      await customUpdate("delete from alternativas_db;");
      await customUpdate("delete from arquivos_audio_db;");
      await customUpdate("delete from arquivos_video_db;");
      await customUpdate("delete from arquivos_db;");
      await customUpdate("delete from contextos_prova_db;");
      await customUpdate("delete from download_provas_db;");
      await customUpdate("delete from prova_aluno_table;");
      await customUpdate("delete from prova_caderno_table;");
      await customUpdate("delete from provas_db;");
      await customUpdate("delete from questao_arquivo_table;");
      await customUpdate("delete from questoes_db;");
      await customUpdate("delete from jobs_table;");
    });
  }
}
