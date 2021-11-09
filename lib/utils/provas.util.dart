import 'package:appserap/database/app.database.dart';
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

removerProvaLocal(ProvaStore provaStore) async {
  AppDatabase db = GetIt.I.get();

  await db.limparPorProvaId(provaStore.prova.id);

  // Remove prova do cache
  SharedPreferences prefs = ServiceLocator.get();
  await prefs.remove('prova_${provaStore.prova.id}');

  // Remove respostas da prova do cache
  for (var questoes in provaStore.prova.questoes) {
    await prefs.remove('resposta_${questoes.id}');
  }
}
