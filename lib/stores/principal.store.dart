import 'package:appserap/database/app.database.dart';
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
  }

  final usuario = GetIt.I.get<UsuarioStore>();

  @observable
  ObservableStream<ConnectivityResult> conexaoStream = ObservableStream(Connectivity().onConnectivityChanged);

  ReactionDisposer? _disposer;

  setup() async {
    _disposer = reaction((_) => conexaoStream.value, onChangeConexao);
    await obterVersaoDoApp();
  }

  void dispose() {
    _disposer!();
  }

  @observable
  ConnectivityResult status = ConnectivityResult.none;

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
  Future<void> obterVersaoDoApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versaoApp = "Versão ${packageInfo.version}.${packageInfo.buildNumber}";
  }

  @action
  Future<void> sair() async {
    AppDatabase db = GetIt.I.get();

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

    await db.respostaProvaDao.removerSincronizadas();

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
    SharedPreferences prefs = GetIt.I.get();

    for (var item in prefs.getKeys()) {
      if (!item.startsWith('_')) {
        await prefs.remove(item);
      }
    }
  }
}
