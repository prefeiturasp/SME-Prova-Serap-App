import 'package:appserap/database/app.database.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<int> getProvasCache() {
  SharedPreferences prefs = GetIt.I.get();

  var ids = prefs.getKeys().toList().where((element) => element.startsWith('prova_'));

  if (ids.isNotEmpty) {
    return ids.map((e) => e.replaceAll('prova_', '')).map((e) => int.parse(e)).toList();
  }
  return [];
}

Future<List<int>> getProvasCacheIds() async {
  AppDatabase db = GetIt.I.get();
  var provas = await db.provaDao.obterIds();
  if (provas.isNotEmpty) {
    return provas;
  }
  return [];
}
