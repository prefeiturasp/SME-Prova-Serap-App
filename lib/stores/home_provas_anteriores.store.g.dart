// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provas_anteriores.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeProvasAnterioresStore on _HomeProvasAnterioresStoreBase, Store {
  late final _$isLoadingAtom =
      Atom(name: '_HomeProvasAnterioresStoreBase.isLoading', context: context);

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

  late final _$provasAnterioresAtom = Atom(
      name: '_HomeProvasAnterioresStoreBase.provasAnteriores',
      context: context);

  @override
  ObservableList<ProvaAnteriorResponseDTO> get provasAnteriores {
    _$provasAnterioresAtom.reportRead();
    return super.provasAnteriores;
  }

  @override
  set provasAnteriores(ObservableList<ProvaAnteriorResponseDTO> value) {
    _$provasAnterioresAtom.reportWrite(value, super.provasAnteriores, () {
      super.provasAnteriores = value;
    });
  }

  late final _$carregarProvasAnterioresAsyncAction = AsyncAction(
      '_HomeProvasAnterioresStoreBase.carregarProvasAnteriores',
      context: context);

  @override
  Future<void> carregarProvasAnteriores() {
    return _$carregarProvasAnterioresAsyncAction
        .run(() => super.carregarProvasAnteriores());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
provasAnteriores: ${provasAnteriores}
    ''';
  }
}
