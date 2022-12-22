// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_tai.view.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProvaTaiViewStore on _ProvaTaiViewStoreBase, Store {
  late final _$carregandoAtom =
      Atom(name: '_ProvaTaiViewStoreBase.carregando', context: context);

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

  late final _$taiDisponivelAtom =
      Atom(name: '_ProvaTaiViewStoreBase.taiDisponivel', context: context);

  @override
  bool get taiDisponivel {
    _$taiDisponivelAtom.reportRead();
    return super.taiDisponivel;
  }

  @override
  set taiDisponivel(bool value) {
    _$taiDisponivelAtom.reportWrite(value, super.taiDisponivel, () {
      super.taiDisponivel = value;
    });
  }

  late final _$provaStoreAtom =
      Atom(name: '_ProvaTaiViewStoreBase.provaStore', context: context);

  @override
  ProvaStore? get provaStore {
    _$provaStoreAtom.reportRead();
    return super.provaStore;
  }

  @override
  set provaStore(ProvaStore? value) {
    _$provaStoreAtom.reportWrite(value, super.provaStore, () {
      super.provaStore = value;
    });
  }

  late final _$configurarProvaAsyncAction =
      AsyncAction('_ProvaTaiViewStoreBase.configurarProva', context: context);

  @override
  Future<bool?> configurarProva(int provaId) {
    return _$configurarProvaAsyncAction
        .run(() => super.configurarProva(provaId));
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
taiDisponivel: ${taiDisponivel},
provaStore: ${provaStore}
    ''';
  }
}
