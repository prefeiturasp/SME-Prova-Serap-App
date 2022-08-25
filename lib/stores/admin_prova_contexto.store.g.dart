// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova_contexto.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdminProvaContextoViewStore on _AdminProvaContextoViewStoreBase, Store {
  late final _$carregandoAtom = Atom(
      name: '_AdminProvaContextoViewStoreBase.carregando', context: context);

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

  late final _$contextosProvaAtom = Atom(
      name: '_AdminProvaContextoViewStoreBase.contextosProva',
      context: context);

  @override
  ObservableList<ContextoProvaResponseDTO> get contextosProva {
    _$contextosProvaAtom.reportRead();
    return super.contextosProva;
  }

  @override
  set contextosProva(ObservableList<ContextoProvaResponseDTO> value) {
    _$contextosProvaAtom.reportWrite(value, super.contextosProva, () {
      super.contextosProva = value;
    });
  }

  late final _$carregarContextoAsyncAction = AsyncAction(
      '_AdminProvaContextoViewStoreBase.carregarContexto',
      context: context);

  @override
  Future carregarContexto(int idProva) {
    return _$carregarContextoAsyncAction
        .run(() => super.carregarContexto(idProva));
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
contextosProva: ${contextosProva}
    ''';
  }
}
