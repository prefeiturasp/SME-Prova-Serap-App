import 'package:appserap/utils/app_config.util.dart';
import 'package:drift/drift.dart';
import 'package:drift/web.dart';

/// Obtains a database connection for running drift on the web.
DatabaseConnection connect({bool isInWebWorker = false}) {
  return DatabaseConnection.delayed(Future.sync(() async {
    final webDb = await DriftWebStorage.indexedDbIfSupported('serap');
    final databaseImpl = WebDatabase.withStorage(
      webDb,
      logStatements: AppConfigReader.debugSql(),
    );

    return DatabaseConnection.fromExecutor(databaseImpl);
  }));
}
