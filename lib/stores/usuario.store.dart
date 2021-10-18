import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'usuario.store.g.dart';

class UsuarioStore = _UsuarioStoreBase with _$UsuarioStore;

abstract class _UsuarioStoreBase with Store {
  @observable
  String? token;

  @observable
  DateTime? tokenDataHoraExpiracao;

  @observable
  DateTime? ultimoLogin;

  @observable
  String? nome;

  @observable
  String? codigoEOL;

  @observable
  String? ano;

  @observable
  String? tipoTurno;

  @action
  void dispose() {
    nome = null;
    token = null;
    codigoEOL = null;
    ano = null;
  }

  @action
  Future<void> carregarUsuario() async {
    SharedPreferences prefs = GetIt.I.get();
    nome = prefs.getString("serapUsuarioNome");
    token = prefs.getString("serapUsuarioToken");
    codigoEOL = prefs.getString("serapUsuarioCodigoEOL");
    ano = prefs.getString("serapUsuarioAno");
    tipoTurno = prefs.getString("serapUsuarioTipoTurno");

    if (prefs.getString("ultimoLogin") != null) {
      ultimoLogin = DateTime.tryParse(prefs.getString("ultimoLogin")!);
    }
  }

  @action
  atualizarDados(
      String nome, String codigoEOL, String token, String ano, String tipoTurno, DateTime? ultimoLogin) async {
    this.nome = nome;
    this.token = token;
    this.codigoEOL = codigoEOL;
    this.ano = ano;
    this.tipoTurno = tipoTurno;
    this.ultimoLogin = ultimoLogin;

    SharedPreferences prefs = GetIt.I.get();
    await prefs.setString('serapUsuarioNome', nome);
    await prefs.setString('serapUsuarioToken', token);
    await prefs.setString('serapUsuarioCodigoEOL', codigoEOL);
    await prefs.setString('serapUsuarioAno', ano);
    await prefs.setString('serapUsuarioTipoTurno', tipoTurno);
    if (this.ultimoLogin != null) {
      await prefs.setString('ultimoLogin', ultimoLogin.toString());
    }
  }
}
