import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:drift/web.dart';

AppDatabase constructDb() {
  final db = LazyDatabase(() async {
    final webDb = await DriftWebStorage.indexedDbIfSupported('serap');
    return WebDatabase.withStorage(webDb);
  });

  return AppDatabase(db);
}
