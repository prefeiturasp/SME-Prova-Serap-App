import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'usuario.store.g.dart';

class UsuarioStore = _UsuarioStoreBase with _$UsuarioStore;

abstract class _UsuarioStoreBase with Store {
  @observable
  String? token;

  @observable
  String? tokenDataHoraExpiracao;

  @observable
  String? nome;

  @observable
  String? codigoEOL;

  @observable
  String? ano;

  void dispose() {
    this.nome = null;
    this.token = null;
    this.codigoEOL = null;
    this.ano = null;
  }

  @action
  Future<void> carregarUsuario() async {
    var prefs = await SharedPreferences.getInstance();
    this.nome = prefs.getString("serapUsuarioNome");
    this.token = prefs.getString("serapUsuarioToken");
    this.codigoEOL = prefs.getString("serapUsuarioCodigoEOL");
    this.ano = prefs.getString("serapUsuarioAno");
  }

  @action
  atualizarDados(String nome, String codigoEOL, String token, String ano) async {
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
}
