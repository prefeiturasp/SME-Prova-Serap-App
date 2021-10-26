import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/ui/views/home/home.view.dart';
// import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/views/login/login.view.dart';
import 'package:appserap/ui/views/orientacao_inicial/orientacao_inicial.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class FluxoInicial extends StatelessWidget {
  final _usuarioStore = GetIt.I.get<UsuarioStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return _usuarioStore.isLogado ? OrientacaoInicialView() : LoginView();
    });
  }
}
