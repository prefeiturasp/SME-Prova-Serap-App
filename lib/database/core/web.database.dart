import 'package:appserap/utils/app_config.util.dart';
import 'package:drift/drift.dart';
import 'package:drift/web.dart';

DatabaseConnection connect([String dbName = 'serap', bool external = false]) {
  return DatabaseConnection.delayed(Future.sync(() async {
    final webDb = await DriftWebStorage.indexedDbIfSupported(dbName);
    final databaseImpl = WebDatabase.withStorage(
      webDb,
      logStatements: AppConfigReader.debugSql(),
    );

    return DatabaseConnection(databaseImpl);
  }));
}
