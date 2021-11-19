import 'package:appserap/enums/modalidade.enum.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/views/login/login.view.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:mobx/mobx.dart';

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
    autorun((_) {
      carregarInformacoes();
    });
    super.initState();
  }

  Future<void> carregarInformacoes() async {
    await GetIt.instance.allReady();
    await _principalStore.setup();

    await _principalStore.usuario.carregarUsuario();

    if (_principalStore.temConexao && _principalStore.usuario.isLogado) {
      var responseMeusDados = await GetIt.I.get<ApiService>().auth.meusDados();

      if (responseMeusDados.isSuccessful) {
        var usuarioDados = responseMeusDados.body!;
        if (usuarioDados.nome != "") {
          if (kIsTablet && usuarioDados.tamanhoFonte < 16) {
            usuarioDados.tamanhoFonte = 16;
          }

          _principalStore.usuario.atualizarDados(
            nome: usuarioDados.nome,
            ano: usuarioDados.ano,
            tipoTurno: usuarioDados.tipoTurno,
            tamanhoFonte: usuarioDados.tamanhoFonte,
            familiaFonte: usuarioDados.familiaFonte,
            inicioTurno: usuarioDados.inicioTurno,
            fimTurno: usuarioDados.fimTurno,
            modalidade: ModalidadeEnum.values[usuarioDados.modalidade],
          );
        }
      }
    }

    _temaStore.fonteDoTexto = _principalStore.usuario.familiaFonte!;
    _temaStore.fachadaAlterarTamanhoDoTexto(_principalStore.usuario.tamanhoFonte!, update: false);

    if (_principalStore.usuario.isLogado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginView(),
        ),
      );
    }
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
}
