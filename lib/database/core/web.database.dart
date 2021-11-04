import 'package:appserap/database/app.database.dart';
import 'package:drift/web.dart';

AppDatabase constructDb() {
  return AppDatabase(WebDatabase('db'));
}
