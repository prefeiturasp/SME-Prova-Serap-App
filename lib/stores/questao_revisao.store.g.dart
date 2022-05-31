// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_revisao.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestaoRevisaoStore on _QuestaoRevisaoStoreBase, Store {
  final _$questoesParaRevisarAtom =
      Atom(name: '_QuestaoRevisaoStoreBase.questoesParaRevisar');

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

  final _$posicaoQuestaoSendoRevisadaAtom =
      Atom(name: '_QuestaoRevisaoStoreBase.posicaoQuestaoSendoRevisada');

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

  final _$totalDeQuestoesParaRevisarAtom =
      Atom(name: '_QuestaoRevisaoStoreBase.totalDeQuestoesParaRevisar');

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

  final _$quantidadeDeQuestoesSemRespostasAtom =
      Atom(name: '_QuestaoRevisaoStoreBase.quantidadeDeQuestoesSemRespostas');

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

  final _$botaoOcupadoAtom =
      Atom(name: '_QuestaoRevisaoStoreBase.botaoOcupado');

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

  @override
  String toString() {
    return '''
questoesParaRevisar: ${questoesParaRevisar},
posicaoQuestaoSendoRevisada: ${posicaoQuestaoSendoRevisada},
totalDeQuestoesParaRevisar: ${totalDeQuestoesParaRevisar},
quantidadeDeQuestoesSemRespostas: ${quantidadeDeQuestoesSemRespostas},
botaoOcupado: ${botaoOcupado}
    ''';
  }
}
