// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'principal.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PrincipalStore on _PrincipalStoreBase, Store {
  Computed<String>? _$versaoComputed;

  @override
  String get versao =>
      (_$versaoComputed ??= Computed<String>(() => super.versao,
              name: '_PrincipalStoreBase.versao'))
          .value;

  late final _$dispositivoIdAtom =
      Atom(name: '_PrincipalStoreBase.dispositivoId', context: context);

  @override
  String get dispositivoId {
    _$dispositivoIdAtom.reportRead();
    return super.dispositivoId;
  }

  @override
  set dispositivoId(String value) {
    _$dispositivoIdAtom.reportWrite(value, super.dispositivoId, () {
      super.dispositivoId = value;
    });
  }

  late final _$idDispositivoAtom =
      Atom(name: '_PrincipalStoreBase.idDispositivo', context: context);

  @override
  String get idDispositivo {
    _$idDispositivoAtom.reportRead();
    return super.idDispositivo;
  }

  @override
  set idDispositivo(String value) {
    _$idDispositivoAtom.reportWrite(value, super.idDispositivo, () {
      super.idDispositivo = value;
    });
  }

  late final _$versaoAppAtom =
      Atom(name: '_PrincipalStoreBase.versaoApp', context: context);

  @override
  String get versaoApp {
    _$versaoAppAtom.reportRead();
    return super.versaoApp;
  }

  @override
  set versaoApp(String value) {
    _$versaoAppAtom.reportWrite(value, super.versaoApp, () {
      super.versaoApp = value;
    });
  }

  late final _$temConexaoAtom =
      Atom(name: '_PrincipalStoreBase.temConexao', context: context);

  @override
  bool get temConexao {
    _$temConexaoAtom.reportRead();
    return super.temConexao;
  }

  @override
  set temConexao(bool value) {
    _$temConexaoAtom.reportWrite(value, super.temConexao, () {
      super.temConexao = value;
    });
  }

  late final _$obetIdDispositivoAsyncAction =
      AsyncAction('_PrincipalStoreBase.obetIdDispositivo', context: context);

  @override
  Future<String?> obetIdDispositivo() {
    return _$obetIdDispositivoAsyncAction.run(() => super.obetIdDispositivo());
  }

  late final _$obterVersaoDoAppAsyncAction =
      AsyncAction('_PrincipalStoreBase.obterVersaoDoApp', context: context);

  @override
  Future<void> obterVersaoDoApp() {
    return _$obterVersaoDoAppAsyncAction.run(() => super.obterVersaoDoApp());
  }

  late final _$sairAsyncAction =
      AsyncAction('_PrincipalStoreBase.sair', context: context);

  @override
  Future<void> sair() {
    return _$sairAsyncAction.run(() => super.sair());
  }

  @override
  String toString() {
    return '''
dispositivoId: ${dispositivoId},
idDispositivo: ${idDispositivo},
versaoApp: ${versaoApp},
temConexao: ${temConexao},
versao: ${versao}
    ''';
  }
}
