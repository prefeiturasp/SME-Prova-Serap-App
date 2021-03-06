import 'package:appserap/database/daos/arquivo_video.dao.dart';
import 'package:appserap/database/daos/download_prova.dao.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import 'package:appserap/models/prova_aluno.model.dart';
import 'package:appserap/models/resposta_prova.model.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/alternativa.model.dart';

import 'daos/alternativa.dao.dart';
import 'daos/arquivo.dao.dart';
import 'daos/arquivo_audio.dao.dart';
import 'daos/contexto_prova.dao.dart';
import 'daos/prova.dao.dart';
import 'daos/prova_aluno.dao.dart';
import 'daos/questao.dao.dart';
import 'daos/resposta_prova.dao.dart';
import 'tables/alternativa.table.dart';
import 'tables/arquivo.table.dart';
import 'tables/arquivo_audio.table.dart';
import 'tables/arquivo_video.table.dart';
import 'tables/contexto_prova.table.dart';
import 'tables/download_prova.table.dart';
import 'tables/prova.table.dart';
import 'tables/prova_aluno.table.dart';
import 'tables/questao.table.dart';
import 'tables/resposta_prova.table.dart';

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
    RespostaProvaTable,
    ProvaAlunoTable,
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
    RespostaProvaDao,
    ProvaAlunoDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 19;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
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

        if (from < 11) {
          await m.createTable(respostaProvaTable);
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

        if (from < 16) {
          await m.alterTable(TableMigration(respostaProvaTable));
        }

        if (from < 17) {
          await m.alterTable(TableMigration(arquivosDb));
          await m.alterTable(TableMigration(contextosProvaDb));
        }

        if (from < 18) {
          await m.addColumn(provasDb, provasDb.caderno);
        }

        if (from < 19) {
          await m.addColumn(questoesDb, questoesDb.caderno);
          await m.alterTable(TableMigration(questoesDb));
        }

        // Assert that the schema is valid after migrations
        if (kDebugMode) {
          final wrongForeignKeys = await customSelect('PRAGMA foreign_key_check').get();
          assert(wrongForeignKeys.isEmpty, '${wrongForeignKeys.map((e) => e.data)}');
        }
      }, beforeOpen: (details) async {
        await customStatement('PRAGMA auto_vacuum = FULL;');
        await customStatement('PRAGMA foreign_keys = ON;');

        if (kDebugMode) {
          // This check pulls in a fair amount of code that's not needed
          // anywhere else, so we recommend only doing it in debug builds.
          // await validateDatabaseSchema();
        }
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

      await customUpdate("delete from questoes_db;");

      await customUpdate("delete from arquivos_db;");

      await customUpdate("delete from contextos_prova_db;");

      await customUpdate("delete from arquivos_video_db;");
      await customUpdate("delete from arquivos_audio_db;");

      await customUpdate("delete from provas_db;");

      await customUpdate("delete from download_provas_db;");

      await customUpdate("delete from prova_aluno_table;");
    });
  }
}
