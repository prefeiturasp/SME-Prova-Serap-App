import 'package:appserap/database/daos/arquivo_video.dao.dart';
import 'package:appserap/database/daos/download_prova.dao.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';
import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/models/resposta_prova.model.dart';
import 'package:drift/drift.dart';

import 'daos/alternativa.dao.dart';
import 'daos/arquivo.dao.dart';
import 'daos/arquivo_audio.dao.dart';
import 'daos/contexto_prova.dao.dart';
import 'daos/prova.dao.dart';
import 'daos/questao.dao.dart';
import 'daos/resposta_prova.dao.dart';
import 'tables/alternativa.table.dart';
import 'tables/arquivo.table.dart';
import 'tables/arquivo_audio.table.dart';
import 'tables/arquivo_video.table.dart';
import 'tables/contexto_prova.table.dart';
import 'tables/download_prova.table.dart';
import 'tables/prova.table.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 12;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.addColumn(provasDb, provasDb.senha);
        }
        if (from == 2) {
          await m.addColumn(questoesDb, questoesDb.quantidadeAlternativas);
        }
        if (from == 3) {
          await m.createTable(contextosProvaDb);
        }
        if (from == 4) {
          await m.addColumn(arquivosDb, arquivosDb.legadoId);
        }
        if (from == 5) {
          await m.addColumn(provasDb, provasDb.idDownload);
        }
        if (from == 6) {
          await m.createTable(arquivosVideoDb);
        }
        if (from == 7) {
          await m.createTable(arquivosAudioDb);
        }
        if (from == 8) {
          await m.addColumn(provasDb, provasDb.quantidadeRespostaSincronizacao);
        }
        if (from == 9) {
          await m.createTable(downloadProvasDb);
        }
        if (from == 10) {
          await m.createTable(respostaProvaTable);
        }
        if (from == 11) {
          await m.addColumn(provasDb, provasDb.ultimaAlteracao);
        }
      }, beforeOpen: (details) async {
        await customStatement('PRAGMA auto_vacuum = 1;');
      });

  Future limpar() {
    return transaction(() async {
      await customUpdate("delete from alternativas_db;");

      await customUpdate("delete from questoes_db;");

      await customUpdate("delete from arquivos_db;");

      await customUpdate("delete from contextos_prova_db;");

      await customUpdate("delete from arquivos_video_db;");
      await customUpdate("delete from arquivos_audio_db;");

      await customUpdate("delete from download_provas_db;");

      await customUpdate("delete from provas_db;");
    });
  }

  Future limparPorProvaId(int provaId) {
    return transaction(() async {
      await customUpdate("delete from alternativas_db where prova_id = ?;", variables: [
        Variable.withInt(provaId),
      ]);

      await customUpdate("delete from questoes_db where prova_id = ?;", variables: [
        Variable.withInt(provaId),
      ]);

      await customUpdate("delete from arquivos_db where prova_id = ?;", variables: [
        Variable.withInt(provaId),
      ]);

      await customUpdate("delete from contextos_prova_db where prova_id = ?;", variables: [
        Variable.withInt(provaId),
      ]);

      await customUpdate("delete from arquivos_video_db where prova_id = ?;", variables: [
        Variable.withInt(provaId),
      ]);
      await customUpdate("delete from arquivos_audio_db where prova_id = ?;", variables: [
        Variable.withInt(provaId),
      ]);

      await customUpdate("delete from download_provas_db where prova_id = ?;", variables: [
        Variable.withInt(provaId),
      ]);

      await customUpdate("delete from provas_db where id = ?;", variables: [
        Variable.withInt(provaId),
      ]);
    });
  }
}
