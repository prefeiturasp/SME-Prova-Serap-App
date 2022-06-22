// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contexto_prova_view.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ContextoProvaViewStore on _ContextoProvaViewStoreBase, Store {
  final _$loadingAtom = Atom(name: '_ContextoProvaViewStoreBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$contextoProvaAtom =
      Atom(name: '_ContextoProvaViewStoreBase.contextoProva');

  @override
  List<ContextoProva> get contextoProva {
    _$contextoProvaAtom.reportRead();
    return super.contextoProva;
  }

  @override
  set contextoProva(List<ContextoProva> value) {
    _$contextoProvaAtom.reportWrite(value, super.contextoProva, () {
      super.contextoProva = value;
    });
  }

  final _$carregarContextoProvaAsyncAction =
      AsyncAction('_ContextoProvaViewStoreBase.carregarContextoProva');

  @override
  Future carregarContextoProva(int provaId) {
    return _$carregarContextoProvaAsyncAction
        .run(() => super.carregarContextoProva(provaId));
  }

  @override
  String toString() {
    return '''
loading: ${loading},
contextoProva: ${contextoProva}
    ''';
  }
}
