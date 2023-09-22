// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova_questao.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdminProvaQuestaoViewStore on _AdminProvaQuestaoViewStoreBase, Store {
  late final _$carregandoAtom = Atom(
      name: '_AdminProvaQuestaoViewStoreBase.carregando', context: context);

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
      name: '_AdminProvaQuestaoViewStoreBase.totalQuestoes', context: context);

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

  late final _$detalhesAtom =
      Atom(name: '_AdminProvaQuestaoViewStoreBase.detalhes', context: context);

  @override
  AdminQuestaoDetalhesResponseDTO? get detalhes {
    _$detalhesAtom.reportRead();
    return super.detalhes;
  }

  @override
  set detalhes(AdminQuestaoDetalhesResponseDTO? value) {
    _$detalhesAtom.reportWrite(value, super.detalhes, () {
      super.detalhes = value;
    });
  }

  late final _$questaoAtom =
      Atom(name: '_AdminProvaQuestaoViewStoreBase.questao', context: context);

  @override
  QuestaoResponseDTO? get questao {
    _$questaoAtom.reportRead();
    return super.questao;
  }

  @override
  set questao(QuestaoResponseDTO? value) {
    _$questaoAtom.reportWrite(value, super.questao, () {
      super.questao = value;
    });
  }

  late final _$carregarDetalhesQuestaoAsyncAction = AsyncAction(
      '_AdminProvaQuestaoViewStoreBase.carregarDetalhesQuestao',
      context: context);

  @override
  Future<void> carregarDetalhesQuestao(
      {required int idProva, String? nomeCaderno, required int ordem}) {
    return _$carregarDetalhesQuestaoAsyncAction.run(() => super
        .carregarDetalhesQuestao(
            idProva: idProva, nomeCaderno: nomeCaderno, ordem: ordem));
  }

  late final _$carregarDetalhesAsyncAction = AsyncAction(
      '_AdminProvaQuestaoViewStoreBase.carregarDetalhes',
      context: context);

  @override
  Future carregarDetalhes() {
    return _$carregarDetalhesAsyncAction.run(() => super.carregarDetalhes());
  }

  late final _$_AdminProvaQuestaoViewStoreBaseActionController =
      ActionController(
          name: '_AdminProvaQuestaoViewStoreBase', context: context);

  @override
  dynamic limpar() {
    final _$actionInfo = _$_AdminProvaQuestaoViewStoreBaseActionController
        .startAction(name: '_AdminProvaQuestaoViewStoreBase.limpar');
    try {
      return super.limpar();
    } finally {
      _$_AdminProvaQuestaoViewStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
totalQuestoes: ${totalQuestoes},
detalhes: ${detalhes},
questao: ${questao}
    ''';
  }
}
