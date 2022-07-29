import 'package:appserap/dtos/autenticacao_dados.response.dto.dart';
import 'package:appserap/dtos/error.response.dto.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/exceptions/sem_conexao.exeption.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/notificacao.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/firebase.util.dart';
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
    senha = "";
    codigoEOL = "";
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
  onPostLogin(AutenticacaoDadosResponseDTO usuarioDados) async {
    if (kIsTablet && usuarioDados.tamanhoFonte < 16) {
      usuarioDados.tamanhoFonte = 16;
    }
    defineFonte(usuarioDados.familiaFonte, usuarioDados.tamanhoFonte);
  }

  @action
  defineFonte(FonteTipoEnum familiaFonte, double tamanhoFonte) {
    final _temaStore = GetIt.I.get<TemaStore>();

    _temaStore.fonteDoTexto = familiaFonte;
    _temaStore.fachadaAlterarTamanhoDoTexto(tamanhoFonte, update: false);
  }

  @action
  Future<bool> autenticar() async {
    carregando = true;
    try {
      if (!ServiceLocator.get<PrincipalStore>().temConexao) {
        throw SemConexaoException();
      }

      var responseLogin = await _autenticacaoService.login(
        login: codigoEOL,
        senha: senha,
      );

      if (responseLogin.isSuccessful) {
        var body = responseLogin.body!;

        _usuarioStore.token = body.token;
        _usuarioStore.tokenDataHoraExpiracao = body.dataHoraExpiracao;
        _usuarioStore.ultimoLogin = body.ultimoLogin;
        _usuarioStore.isAdmin = false;

        SharedPreferences prefs = GetIt.I.get();
        await prefs.setString('token', body.token);

        var responseMeusDados = await _autenticacaoService.meusDados();

        if (responseMeusDados.isSuccessful) {
          var usuarioDados = responseMeusDados.body!;
          if (usuarioDados.nome != "") {
            _usuarioStore.atualizarDados(
              codigoEOL: codigoEOL,
              token: body.token,
              nome: usuarioDados.nome,
              ano: usuarioDados.ano,
              tipoTurno: usuarioDados.tipoTurno,
              ultimoLogin: body.ultimoLogin,
              tamanhoFonte: usuarioDados.tamanhoFonte,
              familiaFonte: usuarioDados.familiaFonte,
              inicioTurno: usuarioDados.inicioTurno,
              fimTurno: usuarioDados.fimTurno,
              modalidade: usuarioDados.modalidade,
              dreAbreviacao: usuarioDados.dreAbreviacao,
              escola: usuarioDados.escola,
              turma: usuarioDados.turma,
              deficiencias: usuarioDados.deficiencias,
            );

            await onPostLogin(usuarioDados);
          }
          carregando = false;
          return true;
        } else {
          carregando = false;
          if ((responseMeusDados.error! as dynamic).existemErros) {
            severe((responseMeusDados.error! as dynamic).mensagens.toString());
          }
          return false;
        }
      } else {
        switch (responseLogin.statusCode) {
          case 411:
            autenticacaoErroStore.codigoEOL = (responseLogin.error! as ErrorResponseDTO).mensagens.first;
            break;
          case 412:
            autenticacaoErroStore.senha = (responseLogin.error! as ErrorResponseDTO).mensagens.first;
            break;
          case 500:
            NotificacaoUtil.showSnackbarError("Ocorreu um erro interno. Favor contatar o suporte.");
            break;
        }
      }
    } on SemConexaoException catch (e) {
      NotificacaoUtil.showSnackbarError(e.toString());
    } catch (e, stack) {
      NotificacaoUtil.showSnackbarError("Não foi possível estabelecer uma conexão com o servidor.");
      await recordError(e, stack);
    } finally {
      carregando = false;
    }

    return false;
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
