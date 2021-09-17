import 'package:mobx/mobx.dart';

part 'usuario.store.g.dart';

class UsuarioStore = _UsuarioStoreBase with _$UsuarioStore;

abstract class _UsuarioStoreBase with Store {
  @observable
  String? token;

  @observable
  String? nome;

  @observable
  String? codigoEOL;

  @observable
  String? ano;
}
