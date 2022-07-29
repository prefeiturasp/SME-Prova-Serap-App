// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova_resumo.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AdminProvaResumoViewStore on _AdminProvaResumoViewStoreBase, Store {
  final _$carregandoAtom =
      Atom(name: '_AdminProvaResumoViewStoreBase.carregando');

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

  final _$resumoAtom = Atom(name: '_AdminProvaResumoViewStoreBase.resumo');

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

  final _$carregarResumoAsyncAction =
      AsyncAction('_AdminProvaResumoViewStoreBase.carregarResumo');

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
