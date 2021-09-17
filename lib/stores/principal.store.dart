import 'package:appserap/stores/usuario.store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'principal.store.g.dart';

class PrincipalStore = _PrincipalStoreBase with _$PrincipalStore;

abstract class _PrincipalStoreBase with Store {
  final usuario = GetIt.I.get<UsuarioStore>();

  @action
  Future<void> sair() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
