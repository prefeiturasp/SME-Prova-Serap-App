import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/main.ioc.dart';

mixin class Database {
  AppDatabase db = ServiceLocator.get<AppDatabase>();
  RespostasDatabase dbRespostas = ServiceLocator.get<RespostasDatabase>();
}
