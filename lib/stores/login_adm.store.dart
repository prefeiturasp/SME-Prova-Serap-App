import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_adm.store.g.dart';

class LoginAdmStore = _LoginAdmStoreBase with _$LoginAdmStore;

abstract class _LoginAdmStoreBase with Store, Loggable {
  Future<bool> loginByToken(String login, String nome, String perfil, String chaveApi) async {
    final _autenticacaoService = ServiceLocator.get<ApiService>().auth;
    final _usuarioStore = ServiceLocator.get<UsuarioStore>();

    try {
      var responseLogin = await _autenticacaoService.loginByAuthToken(
        login: login,
        perfil: perfil,
        chaveApi: chaveApi,
      );

      if (responseLogin.isSuccessful) {
        var body = responseLogin.body!;
        _usuarioStore.token = body.token;
        _usuarioStore.tokenDataHoraExpiracao = body.dataHoraExpiracao;
        _usuarioStore.ultimoLogin = body.ultimoLogin;
        _usuarioStore.isAdmin = true;

        _usuarioStore.atualizarDadosAdm(
          codigoEOL: login,
          token: body.token,
          nome: nome,
        );

        var prefs = ServiceLocator.get<SharedPreferences>();
        await prefs.setString('token', body.token);

        return true;
      }
    } catch (e, stacktrace) {
      severe("Erro ao fazer login");
      severe(stacktrace);
      severe(e);
    }

    return false;
  }
}
