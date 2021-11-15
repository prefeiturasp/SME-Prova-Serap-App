import 'package:appserap/database/app.database.dart';
import 'package:drift/web.dart';

Future<AppDatabase> constructDb() async {
  return AppDatabase(WebDatabase.withStorage(await DriftWebStorage.indexedDbIfSupported('db')));
}
