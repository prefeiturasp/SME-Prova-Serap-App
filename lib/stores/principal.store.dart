import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'principal.store.g.dart';

class PrincipalStore = _PrincipalStoreBase with _$PrincipalStore;

abstract class _PrincipalStoreBase with Store, Loggable {
  _PrincipalStoreBase() {
    Connectivity().checkConnectivity().then((value) => status = value);
    obetIdDispositivo().then((value) => dispositivoId = value!);
  }

  final usuario = GetIt.I.get<UsuarioStore>();

  @observable
  ObservableStream<ConnectivityResult> conexaoStream = ObservableStream(Connectivity().onConnectivityChanged);

  ReactionDisposer? _disposer;

  @observable
  String dispositivoId = "Indefinido";

  Future<void> setup() async {
    _disposer = reaction((_) => conexaoStream.value, onChangeConexao);
    await obterVersaoDoApp();
  }

  void dispose() {
    _disposer!();
  }

  @observable
  ConnectivityResult status = ConnectivityResult.none;

  @observable
  String idDispositivo = "";

  @observable
  String versaoApp = "Versão 0";

  @computed
  bool get temConexao => status != ConnectivityResult.none;

  @computed
  String get versao => "$versaoApp ${status == ConnectivityResult.none ? ' - Sem conexão' : ''}";

  @action
  Future onChangeConexao(ConnectivityResult? resultado) async {
    info("Conexão alterada: $resultado");
    status = resultado!;
  }

  @action
  Future<String?> obetIdDispositivo() async {
    var deviceInfo = DeviceInfoPlugin();

    // Web
    if (kIsWeb) {
      var webBrowserInfo = await deviceInfo.webBrowserInfo;
      return webBrowserInfo.userAgent;
      // Ios
    } else if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
      // Android
    } else if (Platform.isAndroid) {
      const _androidIdPlugin = AndroidId();
      return await _androidIdPlugin.getId();
      // Windows
    } else if (Platform.isWindows) {
      var windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId;
      // MacOS
    } else if (Platform.isMacOS) {
      var macOsInfo = await deviceInfo.macOsInfo;
      return macOsInfo.systemGUID!;
      // Linux
    } else if (Platform.isLinux) {
      var linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.machineId!;
    } else {
      return "Não identificado";
    }
  }

  @action
  Future<void> obterVersaoDoApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber.isEmpty ? '0' : packageInfo.buildNumber);
    versaoApp = "Versão ${packageInfo.version}.$buildNumber";
  }

  @action
  Future<void> sair() async {
    AppDatabase db = GetIt.I.get();
    RespostasDatabase dbRespostas = GetIt.I.get();

    await setUserIdentifier("");

    try {
      List<Prova> provas = await db.provaDao.listarTodos();

      if (provas.isNotEmpty) {
        List<String> downlodIds = provas
            .where((element) => element.downloadStatus == EnumDownloadStatus.CONCLUIDO)
            .toList()
            .map((element) => element.idDownload!)
            .toList();

        await ServiceLocator.get<ApiService>().download.removerDownloads(
              chaveAPI: AppConfigReader.getChaveApi(),
              ids: downlodIds,
            );
      }
    } catch (e, stack) {
      await recordError(e, stack, reason: "Erro ao remover downloads");
    }

    await _limparDadosLocais();

    await dbRespostas.respostaProvaDao.removerSincronizadas();

    await db.limpar();

    await limparMemoriaProvas();

    bool eraAdimin = usuario.isAdmin;

    usuario.dispose();

    if (eraAdimin) {
      await launchUrl(Uri.parse(AppConfigReader.getSerapUrl()), webOnlyWindowName: '_self');
      ServiceLocator.get<AppRouter>().router.go("/login");
    }
  }

  limparMemoriaProvas() async {
    var homeStore = ServiceLocator.get<HomeStore>();

    homeStore.provas.forEach((key, value) {
      value.onDispose();
    });

    homeStore.provas.clear();
  }

  _limparDadosLocais() async {
    SharedPreferences prefs = await ServiceLocator.getAsync();

    for (var item in prefs.getKeys()) {
      if (!item.startsWith('_')) {
        await prefs.remove(item);
      }
    }
  }
}
