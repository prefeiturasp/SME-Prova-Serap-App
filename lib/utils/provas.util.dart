import 'package:appserap/database/app.database.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/stores/prova.store.dart';

import '../main.ioc.dart';

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

removerProvaLocal(ProvaStore provaStore) async {
  AppDatabase db = GetIt.I.get();

  await db.limparPorProvaId(provaStore.prova.id);

  // Remove prova do cache
  SharedPreferences prefs = ServiceLocator.get();
  await prefs.remove('prova_${provaStore.prova.id}');

  // Remove respostas da prova do cache
  for (var questoes in provaStore.prova.questoes) {
    var codigoEOL = ServiceLocator.get<UsuarioStore>().codigoEOL;
    await prefs.remove('resposta_${codigoEOL}_${questoes.id}');
  }
}
