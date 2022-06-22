// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'principal.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

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

  final _$conexaoStreamAtom = Atom(name: '_PrincipalStoreBase.conexaoStream');

  @override
  ObservableStream<ConnectivityStatus> get conexaoStream {
    _$conexaoStreamAtom.reportRead();
    return super.conexaoStream;
  }

  @override
  set conexaoStream(ObservableStream<ConnectivityStatus> value) {
    _$conexaoStreamAtom.reportWrite(value, super.conexaoStream, () {
      super.conexaoStream = value;
    });
  }

  final _$statusAtom = Atom(name: '_PrincipalStoreBase.status');

  @override
  ConnectivityStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(ConnectivityStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$versaoAppAtom = Atom(name: '_PrincipalStoreBase.versaoApp');

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

  final _$onChangeConexaoAsyncAction =
      AsyncAction('_PrincipalStoreBase.onChangeConexao');

  @override
  Future<dynamic> onChangeConexao(ConnectivityStatus? resultado) {
    return _$onChangeConexaoAsyncAction
        .run(() => super.onChangeConexao(resultado));
  }

  final _$obterVersaoDoAppAsyncAction =
      AsyncAction('_PrincipalStoreBase.obterVersaoDoApp');

  @override
  Future<void> obterVersaoDoApp() {
    return _$obterVersaoDoAppAsyncAction.run(() => super.obterVersaoDoApp());
  }

  final _$sairAsyncAction = AsyncAction('_PrincipalStoreBase.sair');

  @override
  Future<void> sair() {
    return _$sairAsyncAction.run(() => super.sair());
  }

  @override
  String toString() {
    return '''
conexaoStream: ${conexaoStream},
status: ${status},
versaoApp: ${versaoApp},
temConexao: ${temConexao},
versao: ${versao}
    ''';
  }
}
