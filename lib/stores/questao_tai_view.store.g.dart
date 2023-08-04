// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_tai_view.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QuestaoTaiViewStore on _QuestaoTaiViewStoreBase, Store {
  late final _$carregandoAtom =
      Atom(name: '_QuestaoTaiViewStoreBase.carregando', context: context);

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

  late final _$taiDisponivelAtom =
      Atom(name: '_QuestaoTaiViewStoreBase.taiDisponivel', context: context);

  @override
  bool get taiDisponivel {
    _$taiDisponivelAtom.reportRead();
    return super.taiDisponivel;
  }

  @override
  set taiDisponivel(bool value) {
    _$taiDisponivelAtom.reportWrite(value, super.taiDisponivel, () {
      super.taiDisponivel = value;
    });
  }

  late final _$provaStoreAtom =
      Atom(name: '_QuestaoTaiViewStoreBase.provaStore', context: context);

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

  late final _$questaoAtom =
      Atom(name: '_QuestaoTaiViewStoreBase.questao', context: context);

  @override
  QuestaoCompletaTaiResponseDTO? get questao {
    _$questaoAtom.reportRead();
    return super.questao;
  }

  @override
  set questao(QuestaoCompletaTaiResponseDTO? value) {
    _$questaoAtom.reportWrite(value, super.questao, () {
      super.questao = value;
    });
  }

  late final _$alternativaIdMarcadaAtom = Atom(
      name: '_QuestaoTaiViewStoreBase.alternativaIdMarcada', context: context);

  @override
  int? get alternativaIdMarcada {
    _$alternativaIdMarcadaAtom.reportRead();
    return super.alternativaIdMarcada;
  }

  @override
  set alternativaIdMarcada(int? value) {
    _$alternativaIdMarcadaAtom.reportWrite(value, super.alternativaIdMarcada,
        () {
      super.alternativaIdMarcada = value;
    });
  }

  late final _$textoRespondidoAtom =
      Atom(name: '_QuestaoTaiViewStoreBase.textoRespondido', context: context);

  @override
  String? get textoRespondido {
    _$textoRespondidoAtom.reportRead();
    return super.textoRespondido;
  }

  @override
  set textoRespondido(String? value) {
    _$textoRespondidoAtom.reportWrite(value, super.textoRespondido, () {
      super.textoRespondido = value;
    });
  }

  late final _$dataHoraRespostaAtom =
      Atom(name: '_QuestaoTaiViewStoreBase.dataHoraResposta', context: context);

  @override
  DateTime? get dataHoraResposta {
    _$dataHoraRespostaAtom.reportRead();
    return super.dataHoraResposta;
  }

  @override
  set dataHoraResposta(DateTime? value) {
    _$dataHoraRespostaAtom.reportWrite(value, super.dataHoraResposta, () {
      super.dataHoraResposta = value;
    });
  }

  late final _$botaoFinalizarOcupadoAtom = Atom(
      name: '_QuestaoTaiViewStoreBase.botaoFinalizarOcupado', context: context);

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

  late final _$carregarQuestaoAsyncAction =
      AsyncAction('_QuestaoTaiViewStoreBase.carregarQuestao', context: context);

  @override
  Future<dynamic> carregarQuestao(int provaId) {
    return _$carregarQuestaoAsyncAction
        .run(() => super.carregarQuestao(provaId));
  }

  late final _$enviarRespostaAsyncAction =
      AsyncAction('_QuestaoTaiViewStoreBase.enviarResposta', context: context);

  @override
  Future<bool> enviarResposta() {
    return _$enviarRespostaAsyncAction.run(() => super.enviarResposta());
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
taiDisponivel: ${taiDisponivel},
provaStore: ${provaStore},
questao: ${questao},
alternativaIdMarcada: ${alternativaIdMarcada},
textoRespondido: ${textoRespondido},
dataHoraResposta: ${dataHoraResposta},
botaoFinalizarOcupado: ${botaoFinalizarOcupado}
    ''';
  }
}
