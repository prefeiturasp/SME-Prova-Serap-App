import 'dart:developer';

import 'package:appserap/controllers/login.controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
