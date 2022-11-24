// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_resultado_detalhes_view.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QuestaoResultadoDetalhesViewStore
    on _QuestaoResultadoDetalhesViewStoreBase, Store {
  late final _$carregandoAtom = Atom(
      name: '_QuestaoResultadoDetalhesViewStoreBase.carregando',
      context: context);

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

  late final _$detalhesAtom = Atom(
      name: '_QuestaoResultadoDetalhesViewStoreBase.detalhes',
      context: context);

  @override
  QuestaoCompletaRespostaResponseDto? get detalhes {
    _$detalhesAtom.reportRead();
    return super.detalhes;
  }

  @override
  set detalhes(QuestaoCompletaRespostaResponseDto? value) {
    _$detalhesAtom.reportWrite(value, super.detalhes, () {
      super.detalhes = value;
    });
  }

  late final _$questaoAtom = Atom(
      name: '_QuestaoResultadoDetalhesViewStoreBase.questao', context: context);

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
      '_QuestaoResultadoDetalhesViewStoreBase.carregarDetalhesQuestao',
      context: context);

  @override
  Future<void> carregarDetalhesQuestao(
      {required int provaId, required int questaoLegadoId}) {
    return _$carregarDetalhesQuestaoAsyncAction.run(() => super
        .carregarDetalhesQuestao(
            provaId: provaId, questaoLegadoId: questaoLegadoId));
  }

  late final _$carregarDetalhesAsyncAction = AsyncAction(
      '_QuestaoResultadoDetalhesViewStoreBase.carregarDetalhes',
      context: context);

  @override
  Future carregarDetalhes() {
    return _$carregarDetalhesAsyncAction.run(() => super.carregarDetalhes());
  }

  late final _$_QuestaoResultadoDetalhesViewStoreBaseActionController =
      ActionController(
          name: '_QuestaoResultadoDetalhesViewStoreBase', context: context);

  @override
  dynamic limpar() {
    final _$actionInfo =
        _$_QuestaoResultadoDetalhesViewStoreBaseActionController.startAction(
            name: '_QuestaoResultadoDetalhesViewStoreBase.limpar');
    try {
      return super.limpar();
    } finally {
      _$_QuestaoResultadoDetalhesViewStoreBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
detalhes: ${detalhes},
questao: ${questao}
    ''';
  }
}
