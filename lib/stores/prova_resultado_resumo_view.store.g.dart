// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_resultado_resumo_view.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProvaResultadoResumoViewStore
    on _ProvaResultadoResumoViewStoreBase, Store {
  late final _$carregandoAtom = Atom(
      name: '_ProvaResultadoResumoViewStoreBase.carregando', context: context);

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

  late final _$totalQuestoesAtom = Atom(
      name: '_ProvaResultadoResumoViewStoreBase.totalQuestoes',
      context: context);

  @override
  int get totalQuestoes {
    _$totalQuestoesAtom.reportRead();
    return super.totalQuestoes;
  }

  @override
  set totalQuestoes(int value) {
    _$totalQuestoesAtom.reportWrite(value, super.totalQuestoes, () {
      super.totalQuestoes = value;
    });
  }

  late final _$responseAtom = Atom(
      name: '_ProvaResultadoResumoViewStoreBase.response', context: context);

  @override
  ProvaResultadoResumoResponseDto? get response {
    _$responseAtom.reportRead();
    return super.response;
  }

  @override
  set response(ProvaResultadoResumoResponseDto? value) {
    _$responseAtom.reportWrite(value, super.response, () {
      super.response = value;
    });
  }

  late final _$provaAtom =
      Atom(name: '_ProvaResultadoResumoViewStoreBase.prova', context: context);

  @override
  Prova? get prova {
    _$provaAtom.reportRead();
    return super.prova;
  }

  @override
  set prova(Prova? value) {
    _$provaAtom.reportWrite(value, super.prova, () {
      super.prova = value;
    });
  }

  late final _$carregarResumoAsyncAction = AsyncAction(
      '_ProvaResultadoResumoViewStoreBase.carregarResumo',
      context: context);

  @override
  Future carregarResumo({required int provaId, required String caderno}) {
    return _$carregarResumoAsyncAction
        .run(() => super.carregarResumo(provaId: provaId, caderno: caderno));
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
totalQuestoes: ${totalQuestoes},
response: ${response},
prova: ${prova}
    ''';
  }
}
