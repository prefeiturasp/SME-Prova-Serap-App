import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'principal.store.g.dart';

class PrincipalStore = _PrincipalStoreBase with _$PrincipalStore;

abstract class _PrincipalStoreBase with Store {
  final _versaoService = GetIt.I.get<ApiService>().versao;
  final usuario = GetIt.I.get<UsuarioStore>();

  @observable
  ObservableStream<ConnectivityResult> conexaoStream = ObservableStream(Connectivity().onConnectivityChanged);

  ReactionDisposer? _disposer;

  setup() async {
    _disposer = reaction((_) => conexaoStream.value, onChangeConexao);
  }

  void dispose() {
    _disposer!();
  }

  @observable
  ConnectivityResult status = ConnectivityResult.none;

  @observable
  String versaoApp = "Versão 0";

  @computed
  String get versao => "$versaoApp ${status == ConnectivityResult.none ? ' - Sem conexão' : ''}";

  @action
  Future onChangeConexao(ConnectivityResult? resultado) async {
    status = resultado!;
  }

  @action
  Future<void> obterVersaoDoApp() async {
    var versaoAtual = await _versaoService.getVersao();

    //var prefs = await SharedPreferences.getInstance();
    versaoApp = versaoAtual.body!;
    // prefs.getString('versaoApp');
  }

  @action
  Future<void> sair() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    usuario.dispose();
  }
}
