import 'package:appserap/controllers/splash_screen.controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'main.store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store {
  @observable
  ObservableStream<ConnectivityResult> connectivityStream = ObservableStream(Connectivity().onConnectivityChanged);

  @observable
  String? versaoApp = "";

  ReactionDisposer? _disposer;

  void setupReactions() {
    _disposer = reaction((_) => connectivityStream.value, validarConexao);
  }

  @observable
  ConnectivityResult status = ConnectivityResult.none;

  @computed
  String get versao => "$versaoApp ${status == ConnectivityResult.none ? ' - Sem conexão' : ''}";

  void dispose() {
    _disposer!();
  }

  @action
  Future validarConexao(ConnectivityResult? resultado) async {
    status = resultado!;
  }

  @action
  Future<void> obterVersaoDoApp() async {
    var splashController = GetIt.I.get<SplashScreenController>();
    splashController.obterVersaoDoApp();

    var prefs = await SharedPreferences.getInstance();
    versaoApp = prefs.getString('versaoApp');
  }
}
