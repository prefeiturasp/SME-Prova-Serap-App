import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:updater/updater.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> with Loggable {
  final _principalStore = GetIt.I.get<PrincipalStore>();
  final _temaStore = GetIt.I.get<TemaStore>();

  UpdaterController controller = UpdaterController();

  @override
  void initState() {
    autorun((_) {
      carregarInformacoes();
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> carregarInformacoes() async {
    await GetIt.instance.allReady();
    await _principalStore.setup();

    await _principalStore.usuario.carregarUsuario();

    if (_principalStore.temConexao && _principalStore.usuario.isLogado) {
      try {
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
              modalidade: usuarioDados.modalidade,
              dreAbreviacao: usuarioDados.dreAbreviacao,
              escola: usuarioDados.escola,
              turma: usuarioDados.turma,
              deficiencias: usuarioDados.deficiencias,
            );
          }
        }
      } catch (e) {
        await _principalStore.sair();
      }
    }

    _temaStore.fonteDoTexto = _principalStore.usuario.familiaFonte!;
    _temaStore.fachadaAlterarTamanhoDoTexto(_principalStore.usuario.tamanhoFonte!, update: false);

    try {
      if (!(await checkUpdate())) {
        _navegar();
      }
    } catch (e) {
      _navegar();
    }
  }

  _navegar() {
    if (_principalStore.usuario.isLogado) {
      if (_principalStore.usuario.isAdmin) {
        context.go("/admin");
      } else {
        context.go("/");
      }
    } else {
      context.go("/login");
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

  Future<bool> checkUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    info("Versão: ${packageInfo.version} Build: $buildNumber");

    bool isAvailable = await Updater(
      context: context,
      url: AppConfigReader.getApiHost() + "/v1/versoes/atualizacao",
      titleText: 'Atualização disponível!',
      confirmText: "Atualizar",
      backgroundDownload: false,
      allowSkip: false,
      callBack: (versionName, versionCode, contentText, minSupport, downloadUrl) {
        info("Ultima Versão: $versionName Build: $versionCode");
      },
      controller: controller,
    ).check();

    return isAvailable;
  }
}
