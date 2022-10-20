import 'package:appserap/models/resposta_prova.model.dart';
import 'package:drift/drift.dart';

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
class RespostasDatabase extends _$RespostasDatabase {
  RespostasDatabase() : super.connect(impl.connect('respostas', true));

  RespostasDatabase.executor(QueryExecutor e) : super(e);

  RespostasDatabase.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
      beforeOpen: (details) async {
        await customStatement('PRAGMA auto_vacuum = FULL;');
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }
}
