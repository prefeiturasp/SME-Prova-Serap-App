import 'package:appserap/dtos/autenticacao.dto.dart';
import 'package:appserap/dtos/rest/error.dto.dart';
import 'package:appserap/models/token.model.dart';
import 'package:appserap/services/autenticacao.service.dart';
import 'package:appserap/services/usuario.service.dart';
import 'package:appserap/stores/autenticacao_erro.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

part 'autenticacao.store.g.dart';

class AutenticacaoStore = _AutenticacaoStoreBase with _$AutenticacaoStore;

abstract class _AutenticacaoStoreBase with Store {
  final _autenticacaoService = GetIt.I.get<AutenticacaoService>();
  final _usuarioService = GetIt.I.get<UsuarioService>();
  final _usuarioStore = GetIt.I.get<UsuarioStore>();

  final autenticacaoErroStore = GetIt.I.get<AutenticacaoErroStore>();

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
    this.carregando = true;
    var response = await _autenticacaoService.autenticar(new AutenticacaoDTO(
      codigoEOL: this.codigoEOL,
      senha: this.senha,
    ));

    if (response.success) {
      var tokenModel = TokenModel.fromJson(response.content);
      if (tokenModel.token != "") {
        _usuarioStore.token = tokenModel.token;
        _usuarioStore.tokenDataHoraExpiracao = tokenModel.dataHoraExpiracao;

        var usuarioDados = await _usuarioService.obterDados();
        if (usuarioDados.nome != "") {
          _usuarioStore.atualizarDados(usuarioDados.nome, this.codigoEOL, tokenModel.token, usuarioDados.ano);
        }
      }
    } else {
      for (ErrorDTO error in response.errors) {
        switch (error.code) {
          case 411:
            autenticacaoErroStore.codigoEOL = error.message;
            break;
          case 412:
            autenticacaoErroStore.senha = error.message;
            break;
        }
      }
    }
    this.carregando = false;
  }
}
