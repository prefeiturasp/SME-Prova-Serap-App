import 'package:appserap/fluxo_inicial.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/tema.store.dart';
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
  final _temaStore = GetIt.I.get<TemaStore>();
  final _orientacaoStore = GetIt.I.get<OrientacaoInicialStore>();

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
    await _orientacaoStore.popularListaDeOrientacoes();

    if (_principalStore.temConexao && _principalStore.usuario.isLogado) {
      var responseMeusDados = await GetIt.I.get<ApiService>().auth.meusDados();

      if (responseMeusDados.isSuccessful) {
        var usuarioDados = responseMeusDados.body!;
        if (usuarioDados.nome != "") {
          _principalStore.usuario.atualizarDados(
            nome: usuarioDados.nome,
            ano: usuarioDados.ano,
            tipoTurno: usuarioDados.tipoTurno,
            tamanhoFonte: usuarioDados.tamanhoFonte,
            familiaFonte: usuarioDados.familiaFonte,
          );
        }
      }
    }

    _temaStore.fonteDoTexto = _principalStore.usuario.familiaFonte!;
    _temaStore.fachadaAlterarTamanhoDoTexto(_principalStore.usuario.tamanhoFonte!, update: false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FluxoInicial(),
      ),
    );
  }
}
