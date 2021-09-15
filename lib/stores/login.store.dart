import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'login.store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  @observable
  String? mensagemErroEOL = "";

  @observable
  String? mensagemErroSenha = "";

  @observable
  TextEditingController? senhaController = TextEditingController();

  @action
  setMensagemErroEOL(String mensagem) => this.mensagemErroEOL = mensagem;

  @action
  setMensagemErroSenha(String mensagem) => this.mensagemErroSenha = mensagem;
}
