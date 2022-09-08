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
}
