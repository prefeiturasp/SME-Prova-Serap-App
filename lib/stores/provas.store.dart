import 'dart:convert';

import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/index.dart';
import 'package:appserap/services/prova.repository.dart';
import 'package:get_it/get_it.dart';

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'provas.store.g.dart';

class ProvasStore = _ProvasStoreBase with _$ProvasStore;

abstract class _ProvasStoreBase with Store {
  @observable
  List<ProvaModel> provas = [];

  @action
  Future<void> carregarProvasStorage() async {
    provas = await GetIt.I.get<ProvaRepository>().obterProvas();

    //fetchReposFuture = ObservableFuture(future);
  }
}
