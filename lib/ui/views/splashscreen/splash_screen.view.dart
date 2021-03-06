import 'dart:io';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:lottie/lottie.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      } catch (e, stack) {
        await _principalStore.sair();
        await recordError(e, stack);
      }
    }

    _temaStore.fonteDoTexto = _principalStore.usuario.familiaFonte!;
    _temaStore.fachadaAlterarTamanhoDoTexto(_principalStore.usuario.tamanhoFonte!, update: false);

    try {
      if (kDebugMode || !(await checkUpdate())) {
        _navegar();
      }
    } catch (e, stack) {
      _navegar();
      await recordError(e, stack);
    }

    await informarVersao();
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

    info("Vers??o: ${packageInfo.version} Build: $buildNumber");

    bool isAvailable = await Updater(
      context: context,
      url: AppConfigReader.getApiHost() + "/v1/versoes/atualizacao",
      titleText: 'Atualiza????o dispon??vel!',
      confirmText: "Atualizar",
      backgroundDownload: false,
      allowSkip: false,
      callBack: (versionName, versionCode, contentText, minSupport, downloadUrl) {
        info("Ultima Vers??o: $versionName Build: $versionCode");
      },
      controller: controller,
    ).check();

    return isAvailable;
  }

  informarVersao() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    try {
      PermissionStatus status = await Permission.contacts.status;

      if (!status.isGranted) {
        status = await Permission.phone.request();
      } else if (status.isPermanentlyDenied || status.isDenied) {
        await openAppSettings();
      }

      if (status.isGranted) {
        SharedPreferences prefs = ServiceLocator.get();
        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        int buildNumber = prefs.getInt("_buildNumber") ?? 0;
        String version = prefs.getString("_version") ?? "1.0.0";

        String? imei = await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);

        await FirebaseCrashlytics.instance.setCustomKey('imei', imei!);

        if (buildNumber != int.parse(packageInfo.buildNumber) || version != packageInfo.version) {
          info("Informando vers??o...");
          info("IMEI: $imei Vers??o: ${packageInfo.version} Build: ${packageInfo.buildNumber} ");

          if (ServiceLocator.get<PrincipalStore>().temConexao) {
            await GetIt.I.get<ApiService>().versao.informarVersao(
                  chaveAPI: AppConfigReader.getChaveApi(),
                  versaoCodigo: int.parse(packageInfo.buildNumber),
                  versaoDescricao: packageInfo.version,
                  dispositivoImei: imei,
                  atualizadoEm: DateTime.now().toIso8601String(),
                );

            await prefs.setInt("_buildNumber", int.parse(packageInfo.buildNumber));
            await prefs.setString("_version", packageInfo.version);
          }
        }
      }
    } on PlatformException catch (e, stack) {
      await recordError(e, stack, reason: "Erro ao informar vers??o");
    }
  }
}
