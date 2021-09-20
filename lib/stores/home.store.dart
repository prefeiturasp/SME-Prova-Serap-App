import 'package:appserap/stores/provas.store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home.store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  final provas = GetIt.I.get<ProvasStore>();

  @observable
  String? teste;

  setup() async {
    await provas.carregarProvas();
  }

  dispose() {
    provas.limpar();
  }
}
