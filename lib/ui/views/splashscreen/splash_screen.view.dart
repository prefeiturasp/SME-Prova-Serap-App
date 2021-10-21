import 'package:appserap/fluxo_inicial.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final _principalStore = GetIt.I.get<PrincipalStore>();

  @override
  void initState() {
    carregarInformacoes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Lottie.asset('assets/images/students.json'),
        ),
      ),
    );
  }

  Future<void> carregarInformacoes() async {
    Future.delayed(const Duration(seconds: 5), () => "5");
    await GetIt.instance.allReady();
    await _principalStore.setup();

    await _principalStore.usuario.carregarUsuario();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FluxoInicial(),
      ),
    );
  }
}
