import 'package:appserap/dtos/error.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:asuka/snackbars/asuka_snack_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login.store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store, Loggable {
  final _autenticacaoService = GetIt.I.get<ApiService>().auth;
  final _usuarioStore = GetIt.I.get<UsuarioStore>();

  final autenticacaoErroStore = AutenticacaoErroStore();

  late List<ReactionDisposer> _disposers;

  @observable
  String codigoEOL = '';

  @observable
  bool carregando = false;

  @observable
  String senha = '';

  @observable
  bool ocultarSenha = true;

  void setupValidations() {
    _disposers = [
      reaction((_) => codigoEOL, validateCodigoEOL),
      reaction((_) => senha, validateSenha),
    ];
  }

  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  void validateTodos() {
    validateCodigoEOL(codigoEOL);
    validateSenha(senha);
  }

  @action
  setCodigoEOL(String valor) {
    codigoEOL = valor;
  }

  @action
  setSenha(String valor) {
    senha = valor;
  }

  @action
  void validateCodigoEOL(String value) {
    if (value.isEmpty) {
      autenticacaoErroStore.codigoEOL = 'Código EOL obrigatório';
      return;
    }

    autenticacaoErroStore.codigoEOL = null;
  }

  @action
  void validateSenha(String value) {
    autenticacaoErroStore.senha = value.isEmpty ? 'Senha obrigatória' : null;

    if (value.length < 3) {
      autenticacaoErroStore.senha = "A senha deve conter no mínimo 3 caracteres";
    }
  }

  @action
  Future<void> autenticar() async {
    carregando = true;
    try {
      var responseLogin = await _autenticacaoService.login(
        login: codigoEOL,
        senha: senha,
      );

      if (responseLogin.isSuccessful) {
        var body = responseLogin.body!;

        _usuarioStore.token = body.token;
        _usuarioStore.tokenDataHoraExpiracao = body.dataHoraExpiracao;

        SharedPreferences prefs = GetIt.I.get();
        await prefs.setString('token', body.token);

        var responseMeusDados = await _autenticacaoService.meusDados();

        if (responseMeusDados.isSuccessful) {
          var usuarioDados = responseMeusDados.body!;
          if (usuarioDados.nome != "") {
            _usuarioStore.atualizarDados(
              usuarioDados.nome,
              codigoEOL,
              body.token,
              usuarioDados.ano,
              usuarioDados.tipoTurno,
            );

            // TODO registar no topico do ano
          }
        }
      } else {
        switch (responseLogin.statusCode) {
          case 411:
            autenticacaoErroStore.codigoEOL = (responseLogin.error! as ErrorResponseDTO).mensagens.first;
            break;
          case 412:
            autenticacaoErroStore.senha = (responseLogin.error! as ErrorResponseDTO).mensagens.first;
            break;
        }
      }
    } catch (e, stack) {
      AsukaSnackbar.alert("Não foi possível estabelecer uma conexão com o servidor.").show();
      severe(e, stack);
    }
    carregando = false;
  }
}

class AutenticacaoErroStore = _AutenticacaoErroStoreBase with _$AutenticacaoErroStore;

abstract class _AutenticacaoErroStoreBase with Store {
  @observable
  String? codigoEOL;

  @observable
  String? senha;

  @computed
  bool get possuiErros => codigoEOL != null || senha != null;
}
