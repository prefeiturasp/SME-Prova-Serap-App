// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resumo_tai_view.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ResumoTaiViewStore on _ResumoTaiViewStoreBase, Store {
  late final _$carregandoAtom =
      Atom(name: '_ResumoTaiViewStoreBase.carregando', context: context);

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

  late final _$provaStoreAtom =
      Atom(name: '_ResumoTaiViewStoreBase.provaStore', context: context);

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

  late final _$botaoFinalizarOcupadoAtom = Atom(
      name: '_ResumoTaiViewStoreBase.botaoFinalizarOcupado', context: context);

  @override
  bool get botaoFinalizarOcupado {
    _$botaoFinalizarOcupadoAtom.reportRead();
    return super.botaoFinalizarOcupado;
  }

  @override
  set botaoFinalizarOcupado(bool value) {
    _$botaoFinalizarOcupadoAtom.reportWrite(value, super.botaoFinalizarOcupado,
        () {
      super.botaoFinalizarOcupado = value;
    });
  }

  late final _$resumoAtom =
      Atom(name: '_ResumoTaiViewStoreBase.resumo', context: context);

  @override
  ObservableList<ProvaResumoTaiResponseDto>? get resumo {
    _$resumoAtom.reportRead();
    return super.resumo;
  }

  @override
  set resumo(ObservableList<ProvaResumoTaiResponseDto>? value) {
    _$resumoAtom.reportWrite(value, super.resumo, () {
      super.resumo = value;
    });
  }

  late final _$carregarResumoAsyncAction =
      AsyncAction('_ResumoTaiViewStoreBase.carregarResumo', context: context);

  @override
  Future<void> carregarResumo(int provaId) {
    return _$carregarResumoAsyncAction.run(() => super.carregarResumo(provaId));
  }

  late final _$finalizarProvaAsyncAction =
      AsyncAction('_ResumoTaiViewStoreBase.finalizarProva', context: context);

  @override
  Future<void> finalizarProva() {
    return _$finalizarProvaAsyncAction.run(() => super.finalizarProva());
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
provaStore: ${provaStore},
botaoFinalizarOcupado: ${botaoFinalizarOcupado},
resumo: ${resumo}
    ''';
  }
}
