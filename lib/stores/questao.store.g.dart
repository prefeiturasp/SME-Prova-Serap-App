// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QuestaoStore on _QuestaoStoreBase, Store {
  late final _$botaoOcupadoAtom =
      Atom(name: '_QuestaoStoreBase.botaoOcupado', context: context);

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

  late final _$isLoadingAtom =
      Atom(name: '_QuestaoStoreBase.isLoading', context: context);

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
