import 'package:appserap/models/resposta_prova.model.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'core/shared.database.dart' as impl;
import 'daos/resposta_prova.dao.dart';
import 'tables/resposta_prova.table.dart';

part 'respostas.database.g.dart';

@DriftDatabase(
  tables: [
    RespostaProvaTable,
  ],
  daos: [
    RespostaProvaDao,
  ],
)
@Singleton()
class RespostasDatabase extends _$RespostasDatabase {
  RespostasDatabase() : super(impl.connect('respostas', true));

  RespostasDatabase.executor(QueryExecutor e) : super(e);

  RespostasDatabase.connect(DatabaseConnection connection) : super(connection);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        await transaction(() async {
          if (from < 2) {
            await m.addColumn(respostaProvaTable, respostaProvaTable.caderno);
            await m.addColumn(respostaProvaTable, respostaProvaTable.ordem);
          }
        });
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA auto_vacuum = FULL;');
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }
}
