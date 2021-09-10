import 'package:appserap/views/home/home.web.view.dart';
import 'package:appserap/views/login/login.view.dart';
import 'package:appserap/views/login/login.web.view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/views/home/home.view.dart';

class FluxoInicialView extends StatefulWidget {
  const FluxoInicialView({Key? key}) : super(key: key);

  @override
  _FluxoInicialViewState createState() => _FluxoInicialViewState();
}

class _FluxoInicialViewState extends State<FluxoInicialView> {
  final _usuarioStore = GetIt.I.get<UsuarioStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (kIsWeb) {
          return _usuarioStore.token != null ? HomeWebView() : LoginWebView();
        } else {
          return _usuarioStore.token != null ? HomeView() : LoginView();
        }
      },
    );
  }
}
