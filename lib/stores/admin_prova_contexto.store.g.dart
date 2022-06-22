// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova_contexto.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AdminProvaContextoViewStore on _AdminProvaContextoViewStoreBase, Store {
  final _$carregandoAtom =
      Atom(name: '_AdminProvaContextoViewStoreBase.carregando');

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

  final _$contextosProvaAtom =
      Atom(name: '_AdminProvaContextoViewStoreBase.contextosProva');

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

  final _$carregarContextoAsyncAction =
      AsyncAction('_AdminProvaContextoViewStoreBase.carregarContexto');

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
