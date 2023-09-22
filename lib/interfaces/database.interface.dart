import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/main.ioc.dart';

mixin class Database {
  AppDatabase db = sl.get<AppDatabase>();
  RespostasDatabase dbRespostas = sl.get<RespostasDatabase>();
}
