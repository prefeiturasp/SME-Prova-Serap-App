// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'principal.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PrincipalStore on _PrincipalStoreBase, Store {
  Computed<bool>? _$temConexaoComputed;

  @override
  bool get temConexao =>
      (_$temConexaoComputed ??= Computed<bool>(() => super.temConexao,
              name: '_PrincipalStoreBase.temConexao'))
          .value;
  Computed<String>? _$versaoComputed;

  @override
  String get versao =>
      (_$versaoComputed ??= Computed<String>(() => super.versao,
              name: '_PrincipalStoreBase.versao'))
          .value;

  late final _$conexaoStreamAtom =
      Atom(name: '_PrincipalStoreBase.conexaoStream', context: context);

  @override
  ObservableStream<ConnectivityResult> get conexaoStream {
    _$conexaoStreamAtom.reportRead();
    return super.conexaoStream;
  }

  @override
  set conexaoStream(ObservableStream<ConnectivityResult> value) {
    _$conexaoStreamAtom.reportWrite(value, super.conexaoStream, () {
      super.conexaoStream = value;
    });
  }

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

  late final _$statusAtom =
      Atom(name: '_PrincipalStoreBase.status', context: context);

  @override
  ConnectivityResult get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(ConnectivityResult value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
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

  late final _$onChangeConexaoAsyncAction =
      AsyncAction('_PrincipalStoreBase.onChangeConexao', context: context);

  @override
  Future<dynamic> onChangeConexao(ConnectivityResult? resultado) {
    return _$onChangeConexaoAsyncAction
        .run(() => super.onChangeConexao(resultado));
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
conexaoStream: ${conexaoStream},
dispositivoId: ${dispositivoId},
status: ${status},
versaoApp: ${versaoApp},
temConexao: ${temConexao},
versao: ${versao}
    ''';
  }
}
