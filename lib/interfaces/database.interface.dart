import 'package:appserap/database/app.database.dart';
import 'package:appserap/main.ioc.dart';

abstract class Database {
  AppDatabase db = ServiceLocator.get<AppDatabase>();
}
