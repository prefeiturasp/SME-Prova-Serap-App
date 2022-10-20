// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStoreBase, Store {
  late final _$provasAtom =
      Atom(name: '_HomeStoreBase.provas', context: context);

  @override
  ObservableMap<int, ProvaStore> get provas {
    _$provasAtom.reportRead();
    return super.provas;
  }

  @override
  set provas(ObservableMap<int, ProvaStore> value) {
    _$provasAtom.reportWrite(value, super.provas, () {
      super.provas = value;
    });
  }

  late final _$carregandoAtom =
      Atom(name: '_HomeStoreBase.carregando', context: context);

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

  late final _$carregarProvasAsyncAction =
      AsyncAction('_HomeStoreBase.carregarProvas', context: context);

  @override
  Future carregarProvas() {
    return _$carregarProvasAsyncAction.run(() => super.carregarProvas());
  }

  late final _$removerProvaAsyncAction =
      AsyncAction('_HomeStoreBase.removerProva', context: context);

  @override
  Future removerProva(ProvaStore provaStore,
      [bool manterRegistroProva = false]) {
    return _$removerProvaAsyncAction
        .run(() => super.removerProva(provaStore, manterRegistroProva));
  }

  late final _$_HomeStoreBaseActionController =
      ActionController(name: '_HomeStoreBase', context: context);

  @override
  dynamic cancelarTimers() {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.cancelarTimers');
    try {
      return super.cancelarTimers();
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic limpar() {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.limpar');
    try {
      return super.limpar();
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
provas: ${provas},
carregando: ${carregando}
    ''';
  }
}
