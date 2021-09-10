import 'package:appserap/controllers/autenticacao.controller.dart';
import 'package:appserap/stores/login.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/splash_screen.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/views/fluxo_inicial.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final _usuarioStore = GetIt.I.get<UsuarioStore>();
  final _splashStore = GetIt.I.get<SplashScreenStore>();
  final _provaStore = GetIt.I.get<ProvaStore>();
  final _autenticacaoController = GetIt.I.get<AutenticacaoController>();

  @override
  void initState() {
    carregarUsuario();
    _splashStore.obterVersaoDoApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Lottie.asset('assets/images/students.json'),
          // child: SvgPicture.asset(
          //   "assets/images/logo-serap.svg",
          //   width: 500,
          // ),
        ),
      ),
    );
  }

  Future<void> carregarUsuario() async {
    await _usuarioStore.carregarUsuario();
    await _provaStore.carregarMensagem();
    Future.delayed(const Duration(seconds: 5), () => "5");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FluxoInicialView(),
      ),
    );
  }
}
