// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestaoStore on _QuestaoStoreBase, Store {
  final _$botaoOcupadoAtom = Atom(name: '_QuestaoStoreBase.botaoOcupado');

  @override
  bool get botaoOcupado {
    _$botaoOcupadoAtom.reportRead();
    return super.botaoOcupado;
  }

  @override
  set botaoOcupado(bool value) {
    _$botaoOcupadoAtom.reportWrite(value, super.botaoOcupado, () {
      super.botaoOcupado = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_QuestaoStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  @override
  String toString() {
    return '''
botaoOcupado: ${botaoOcupado},
isLoading: ${isLoading}
    ''';
  }
}
