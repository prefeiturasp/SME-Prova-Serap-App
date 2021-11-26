import 'package:appserap/database/app.database.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'principal.store.g.dart';

class PrincipalStore = _PrincipalStoreBase with _$PrincipalStore;

abstract class _PrincipalStoreBase with Store, Loggable {
  final usuario = GetIt.I.get<UsuarioStore>();

  @observable
  ObservableStream<ConnectivityStatus> conexaoStream = ObservableStream(Connectivity().onConnectivityChanged);

  ReactionDisposer? _disposer;

  setup() async {
    _disposer = reaction((_) => conexaoStream.value, onChangeConexao);
    await obterVersaoDoApp();
  }

  void dispose() {
    _disposer!();
  }

  @observable
  ConnectivityStatus status = ConnectivityStatus.wifi;

  @observable
  String versaoApp = "Versão 0";

  @computed
  bool get temConexao => status != ConnectivityStatus.none;

  @computed
  String get versao => "$versaoApp ${status == ConnectivityStatus.none ? ' - Sem conexão' : ''}";

  @action
  Future onChangeConexao(ConnectivityStatus? resultado) async {
    status = resultado!;
  }

  @action
  Future<void> obterVersaoDoApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versaoApp = "Versão ${packageInfo.version}";
  }

  @action
  Future<void> sair() async {
    await _limparDadosLocais();

    AppDatabase db = GetIt.I.get();
    db.limpar();

    usuario.dispose();
  }

  _limparDadosLocais() async {
    SharedPreferences prefs = GetIt.I.get();

    info(prefs.getKeys());

    for (var key in prefs.getKeys()) {
      if (!key.startsWith("resposta_")) {
        await prefs.remove(key);
      }
    }
  }
}
