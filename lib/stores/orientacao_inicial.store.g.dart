// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orientacao_inicial.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrientacaoInicialStore on _OrientacaoInicialStoreBase, Store {
  late final _$listaPaginasOrientacoesAtom = Atom(
      name: '_OrientacaoInicialStoreBase.listaPaginasOrientacoes',
      context: context);

  @override
  ObservableList<ApresentacaoModelWidget> get listaPaginasOrientacoes {
    _$listaPaginasOrientacoesAtom.reportRead();
    return super.listaPaginasOrientacoes;
  }

  @override
  set listaPaginasOrientacoes(ObservableList<ApresentacaoModelWidget> value) {
    _$listaPaginasOrientacoesAtom
        .reportWrite(value, super.listaPaginasOrientacoes, () {
      super.listaPaginasOrientacoes = value;
    });
  }

  late final _$popularListaDeOrientacoesAsyncAction = AsyncAction(
      '_OrientacaoInicialStoreBase.popularListaDeOrientacoes',
      context: context);

  @override
  Future<void> popularListaDeOrientacoes() {
    return _$popularListaDeOrientacoesAsyncAction
        .run(() => super.popularListaDeOrientacoes());
  }

  @override
  String toString() {
    return '''
listaPaginasOrientacoes: ${listaPaginasOrientacoes}
    ''';
  }
}
