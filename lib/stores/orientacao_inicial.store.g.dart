// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orientacao_inicial.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OrientacaoInicialStore on _OrientacaoInicialStoreBase, Store {
  final _$listaPaginasOrientacoesAtom =
      Atom(name: '_OrientacaoInicialStoreBase.listaPaginasOrientacoes');

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

  final _$popularListaDeOrientacoesAsyncAction =
      AsyncAction('_OrientacaoInicialStoreBase.popularListaDeOrientacoes');

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
