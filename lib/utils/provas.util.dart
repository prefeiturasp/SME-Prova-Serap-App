import 'package:appserap/database/app.database.dart';
import 'package:get_it/get_it.dart';

Future<List<int>> getProvasCacheIds() async {
  AppDatabase db = GetIt.I.get();
  var provas = await db.provaDao.obterIds();
  if (provas.isNotEmpty) {
    return provas;
  }
  return [];
}
