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
    SharedPreferences prefs = await GetIt.I.getAsync();
    nome = prefs.getString("serapUsuarioNome");
    token = prefs.getString("serapUsuarioToken");
    codigoEOL = prefs.getString("serapUsuarioCodigoEOL");
    ano = prefs.getString("serapUsuarioAno");
    tipoTurno = prefs.getString("serapUsuarioTipoTurno");
  }

  @action
  atualizarDados(String nome, String codigoEOL, String token, String ano, String tipoTurno) async {
    this.nome = nome;
    this.token = token;
    this.codigoEOL = codigoEOL;
    this.ano = ano;
    this.tipoTurno = tipoTurno;

    SharedPreferences prefs = await GetIt.I.getAsync();
    await prefs.setString('serapUsuarioNome', nome);
    await prefs.setString('serapUsuarioToken', token);
    await prefs.setString('serapUsuarioCodigoEOL', codigoEOL);
    await prefs.setString('serapUsuarioAno', ano);
    await prefs.setString('serapUsuarioTipoTurno', tipoTurno);
  }
}
