// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on _LoginStoreBase, Store {
  late final _$codigoEOLAtom =
      Atom(name: '_LoginStoreBase.codigoEOL', context: context);

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

  late final _$carregandoAtom =
      Atom(name: '_LoginStoreBase.carregando', context: context);

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

  late final _$senhaAtom =
      Atom(name: '_LoginStoreBase.senha', context: context);

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

  late final _$ocultarSenhaAtom =
      Atom(name: '_LoginStoreBase.ocultarSenha', context: context);

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

  late final _$onPostLoginAsyncAction =
      AsyncAction('_LoginStoreBase.onPostLogin', context: context);

  @override
  Future onPostLogin(AutenticacaoDadosResponseDTO usuarioDados) {
    return _$onPostLoginAsyncAction.run(() => super.onPostLogin(usuarioDados));
  }

  late final _$autenticarAsyncAction =
      AsyncAction('_LoginStoreBase.autenticar', context: context);

  @override
  Future<bool> autenticar() {
    return _$autenticarAsyncAction.run(() => super.autenticar());
  }

  late final _$_LoginStoreBaseActionController =
      ActionController(name: '_LoginStoreBase', context: context);

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

  late final _$codigoEOLAtom =
      Atom(name: '_AutenticacaoErroStoreBase.codigoEOL', context: context);

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

  late final _$senhaAtom =
      Atom(name: '_AutenticacaoErroStoreBase.senha', context: context);

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
