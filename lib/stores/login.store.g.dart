// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on _LoginStoreBase, Store {
  final _$codigoEOLAtom = Atom(name: '_LoginStoreBase.codigoEOL');

  @override
  String get codigoEOL {
    _$codigoEOLAtom.reportRead();
    return super.codigoEOL;
  }

  @override
  set codigoEOL(String value) {
    _$codigoEOLAtom.reportWrite(value, super.codigoEOL, () {
      super.codigoEOL = value;
    });
  }

  final _$carregandoAtom = Atom(name: '_LoginStoreBase.carregando');

  @override
  bool get carregando {
    _$carregandoAtom.reportRead();
    return super.carregando;
  }

  @override
  set carregando(bool value) {
    _$carregandoAtom.reportWrite(value, super.carregando, () {
      super.carregando = value;
    });
  }

  final _$senhaAtom = Atom(name: '_LoginStoreBase.senha');

  @override
  String get senha {
    _$senhaAtom.reportRead();
    return super.senha;
  }

  @override
  set senha(String value) {
    _$senhaAtom.reportWrite(value, super.senha, () {
      super.senha = value;
    });
  }

  final _$ocultarSenhaAtom = Atom(name: '_LoginStoreBase.ocultarSenha');

  @override
  bool get ocultarSenha {
    _$ocultarSenhaAtom.reportRead();
    return super.ocultarSenha;
  }

  @override
  set ocultarSenha(bool value) {
    _$ocultarSenhaAtom.reportWrite(value, super.ocultarSenha, () {
      super.ocultarSenha = value;
    });
  }

  final _$onPostLoginAsyncAction = AsyncAction('_LoginStoreBase.onPostLogin');

  @override
  Future onPostLogin(AutenticacaoDadosResponseDTO usuarioDados) {
    return _$onPostLoginAsyncAction.run(() => super.onPostLogin(usuarioDados));
  }

  final _$autenticarAsyncAction = AsyncAction('_LoginStoreBase.autenticar');

  @override
  Future<bool> autenticar() {
    return _$autenticarAsyncAction.run(() => super.autenticar());
  }

  final _$_LoginStoreBaseActionController =
      ActionController(name: '_LoginStoreBase');

  @override
  dynamic setCodigoEOL(String valor) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.setCodigoEOL');
    try {
      return super.setCodigoEOL(valor);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setSenha(String valor) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.setSenha');
    try {
      return super.setSenha(valor);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateCodigoEOL(String value) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.validateCodigoEOL');
    try {
      return super.validateCodigoEOL(value);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void validateSenha(String value) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.validateSenha');
    try {
      return super.validateSenha(value);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic defineFonte(FonteTipoEnum familiaFonte, double tamanhoFonte) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase.defineFonte');
    try {
      return super.defineFonte(familiaFonte, tamanhoFonte);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
codigoEOL: ${codigoEOL},
carregando: ${carregando},
senha: ${senha},
ocultarSenha: ${ocultarSenha}
    ''';
  }
}

mixin _$AutenticacaoErroStore on _AutenticacaoErroStoreBase, Store {
  Computed<bool>? _$possuiErrosComputed;

  @override
  bool get possuiErros =>
      (_$possuiErrosComputed ??= Computed<bool>(() => super.possuiErros,
              name: '_AutenticacaoErroStoreBase.possuiErros'))
          .value;

  final _$codigoEOLAtom = Atom(name: '_AutenticacaoErroStoreBase.codigoEOL');

  @override
  String? get codigoEOL {
    _$codigoEOLAtom.reportRead();
    return super.codigoEOL;
  }

  @override
  set codigoEOL(String? value) {
    _$codigoEOLAtom.reportWrite(value, super.codigoEOL, () {
      super.codigoEOL = value;
    });
  }

  final _$senhaAtom = Atom(name: '_AutenticacaoErroStoreBase.senha');

  @override
  String? get senha {
    _$senhaAtom.reportRead();
    return super.senha;
  }

  @override
  set senha(String? value) {
    _$senhaAtom.reportWrite(value, super.senha, () {
      super.senha = value;
    });
  }

  @override
  String toString() {
    return '''
codigoEOL: ${codigoEOL},
senha: ${senha},
possuiErros: ${possuiErros}
    ''';
  }
}
