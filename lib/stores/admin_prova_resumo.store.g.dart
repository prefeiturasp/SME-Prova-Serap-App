// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova_resumo.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdminProvaResumoViewStore on _AdminProvaResumoViewStoreBase, Store {
  late final _$carregandoAtom =
      Atom(name: '_AdminProvaResumoViewStoreBase.carregando', context: context);

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

  late final _$resumoAtom =
      Atom(name: '_AdminProvaResumoViewStoreBase.resumo', context: context);

  @override
  ObservableList<AdminProvaResumoResponseDTO> get resumo {
    _$resumoAtom.reportRead();
    return super.resumo;
  }

  @override
  set resumo(ObservableList<AdminProvaResumoResponseDTO> value) {
    _$resumoAtom.reportWrite(value, super.resumo, () {
      super.resumo = value;
    });
  }

  late final _$carregarResumoAsyncAction = AsyncAction(
      '_AdminProvaResumoViewStoreBase.carregarResumo',
      context: context);

  @override
  Future carregarResumo(int idProva, {String? caderno}) {
    return _$carregarResumoAsyncAction
        .run(() => super.carregarResumo(idProva, caderno: caderno));
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
resumo: ${resumo}
    ''';
  }
}
