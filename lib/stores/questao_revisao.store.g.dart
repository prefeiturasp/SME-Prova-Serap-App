// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_revisao.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QuestaoRevisaoStore on _QuestaoRevisaoStoreBase, Store {
  late final _$questoesParaRevisarAtom = Atom(
      name: '_QuestaoRevisaoStoreBase.questoesParaRevisar', context: context);

  @override
  ObservableList<Questao> get questoesParaRevisar {
    _$questoesParaRevisarAtom.reportRead();
    return super.questoesParaRevisar;
  }

  @override
  set questoesParaRevisar(ObservableList<Questao> value) {
    _$questoesParaRevisarAtom.reportWrite(value, super.questoesParaRevisar, () {
      super.questoesParaRevisar = value;
    });
  }

  late final _$mapaDeQuestoesAtom =
      Atom(name: '_QuestaoRevisaoStoreBase.mapaDeQuestoes', context: context);

  @override
  ObservableList<Map<String, dynamic>> get mapaDeQuestoes {
    _$mapaDeQuestoesAtom.reportRead();
    return super.mapaDeQuestoes;
  }

  @override
  set mapaDeQuestoes(ObservableList<Map<String, dynamic>> value) {
    _$mapaDeQuestoesAtom.reportWrite(value, super.mapaDeQuestoes, () {
      super.mapaDeQuestoes = value;
    });
  }

  late final _$posicaoQuestaoSendoRevisadaAtom = Atom(
      name: '_QuestaoRevisaoStoreBase.posicaoQuestaoSendoRevisada',
      context: context);

  @override
  int get posicaoQuestaoSendoRevisada {
    _$posicaoQuestaoSendoRevisadaAtom.reportRead();
    return super.posicaoQuestaoSendoRevisada;
  }

  @override
  set posicaoQuestaoSendoRevisada(int value) {
    _$posicaoQuestaoSendoRevisadaAtom
        .reportWrite(value, super.posicaoQuestaoSendoRevisada, () {
      super.posicaoQuestaoSendoRevisada = value;
    });
  }

  late final _$totalDeQuestoesParaRevisarAtom = Atom(
      name: '_QuestaoRevisaoStoreBase.totalDeQuestoesParaRevisar',
      context: context);

  @override
  int get totalDeQuestoesParaRevisar {
    _$totalDeQuestoesParaRevisarAtom.reportRead();
    return super.totalDeQuestoesParaRevisar;
  }

  @override
  set totalDeQuestoesParaRevisar(int value) {
    _$totalDeQuestoesParaRevisarAtom
        .reportWrite(value, super.totalDeQuestoesParaRevisar, () {
      super.totalDeQuestoesParaRevisar = value;
    });
  }

  late final _$quantidadeDeQuestoesSemRespostasAtom = Atom(
      name: '_QuestaoRevisaoStoreBase.quantidadeDeQuestoesSemRespostas',
      context: context);

  @override
  int get quantidadeDeQuestoesSemRespostas {
    _$quantidadeDeQuestoesSemRespostasAtom.reportRead();
    return super.quantidadeDeQuestoesSemRespostas;
  }

  @override
  set quantidadeDeQuestoesSemRespostas(int value) {
    _$quantidadeDeQuestoesSemRespostasAtom
        .reportWrite(value, super.quantidadeDeQuestoesSemRespostas, () {
      super.quantidadeDeQuestoesSemRespostas = value;
    });
  }

  late final _$botaoOcupadoAtom =
      Atom(name: '_QuestaoRevisaoStoreBase.botaoOcupado', context: context);

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

  late final _$botaoFinalizarOcupadoAtom = Atom(
      name: '_QuestaoRevisaoStoreBase.botaoFinalizarOcupado', context: context);

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

  late final _$isLoadingAtom =
      Atom(name: '_QuestaoRevisaoStoreBase.isLoading', context: context);

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
questoesParaRevisar: ${questoesParaRevisar},
mapaDeQuestoes: ${mapaDeQuestoes},
posicaoQuestaoSendoRevisada: ${posicaoQuestaoSendoRevisada},
totalDeQuestoesParaRevisar: ${totalDeQuestoesParaRevisar},
quantidadeDeQuestoesSemRespostas: ${quantidadeDeQuestoesSemRespostas},
botaoOcupado: ${botaoOcupado},
botaoFinalizarOcupado: ${botaoFinalizarOcupado},
isLoading: ${isLoading}
    ''';
  }
}
