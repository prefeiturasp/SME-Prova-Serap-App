import 'package:appserap/services/principal.service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'main.store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store {
  final _principalService = GetIt.I.get<PrincipalService>();

  @observable
  ObservableStream<ConnectivityResult> connectivityStream = ObservableStream(Connectivity().onConnectivityChanged);

  @observable
  String? versaoApp = "";

  ReactionDisposer? _disposer;

  void setupReactions() {
    _disposer = reaction((_) => connectivityStream.value, onChangeConexao);
  }

  void dispose() {
    _disposer!();
  }

  @observable
  ConnectivityResult status = ConnectivityResult.none;

  @computed
  String get versao => "$versaoApp ${status == ConnectivityResult.none ? ' - Sem conexão' : ''}";

  @action
  Future onChangeConexao(ConnectivityResult? resultado) async {
    status = resultado!;
  }

  @action
  Future<void> obterVersaoDoApp() async {
    var versaoAtual = await _principalService.obterVersaoDoApp();

    var prefs = await SharedPreferences.getInstance();
    versaoApp = versaoAtual;
    // prefs.getString('versaoApp');
  }
}
