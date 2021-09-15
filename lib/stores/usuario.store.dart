import 'package:appserap/stores/prova.store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'usuario.store.g.dart';

class UsuarioStore = _UsuarioStoreBase with _$UsuarioStore;

abstract class _UsuarioStoreBase with Store {
  final _provaStore = GetIt.I.get<ProvaStore>();

  @observable
  String? token;

  @observable
  String? nome;

  @observable
  String? codigoEOL;

  @observable
  String? ano;

  @action
  Future<void> carregarUsuario() async {
    var prefs = await SharedPreferences.getInstance();
    this.nome = prefs.getString("serapUsuarioNome");
    this.token = prefs.getString("serapUsuarioToken");
    this.codigoEOL = prefs.getString("serapUsuarioCodigoEOL");
    this.ano = prefs.getString("serapUsuarioAno");
  }

  @action
  atualizarDados(
      String nome, String codigoEOL, String token, String ano) async {
    this.nome = nome;
    this.token = token;
    this.codigoEOL = codigoEOL;
    this.ano = ano;

    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('serapUsuarioNome', nome);
    await prefs.setString('serapUsuarioToken', token);
    await prefs.setString('serapUsuarioCodigoEOL', codigoEOL);
    await prefs.setString('serapUsuarioAno', ano);
  }

  @action
  Future<void> limparUsuario() async {
    var prefs = await SharedPreferences.getInstance();
    await _provaStore.limparProvas();
    await prefs.clear();
  }

  @observable
  String? mensagem = "";

  @action
  Future<void> obterMensagem() async {
    var prefs = await SharedPreferences.getInstance();
    print(prefs.getString("testeMensagem").runtimeType);
    this.mensagem = prefs.getString("testeMensagem");
    print(mensagem);
  }
}
