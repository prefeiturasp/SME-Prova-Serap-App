// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_resposta.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProvaRespostaStore on _ProvaRespostaStoreBase, Store {
  late final _$idProvaAtom =
      Atom(name: '_ProvaRespostaStoreBase.idProva', context: context);

  @override
  int get idProva {
    _$idProvaAtom.reportRead();
    return super.idProva;
  }

  @override
  set idProva(int value) {
    _$idProvaAtom.reportWrite(value, super.idProva, () {
      super.idProva = value;
    });
  }

  late final _$codigoEOLAtom =
      Atom(name: '_ProvaRespostaStoreBase.codigoEOL', context: context);

  @override
  String get codigoEOL {
    _$codigoEOLAtom.reportRead();
    return super.codigoEOL;
  }

  @override
  set codigoEOL(String value) {
    _$codigoEOLAtom.reportWrite(value, super.codigoEOL, () {
      super.codigoEOL = value;
    });
  }

  late final _$respostasLocalAtom =
      Atom(name: '_ProvaRespostaStoreBase.respostasLocal', context: context);

  @override
  ObservableMap<int, RespostaProva> get respostasLocal {
    _$respostasLocalAtom.reportRead();
    return super.respostasLocal;
  }

  @override
  set respostasLocal(ObservableMap<int, RespostaProva> value) {
    _$respostasLocalAtom.reportWrite(value, super.respostasLocal, () {
      super.respostasLocal = value;
    });
  }

  late final _$carregarRespostasServidorAsyncAction = AsyncAction(
      '_ProvaRespostaStoreBase.carregarRespostasServidor',
      context: context);

  @override
  Future<void> carregarRespostasServidor() {
    return _$carregarRespostasServidorAsyncAction
        .run(() => super.carregarRespostasServidor());
  }

  late final _$sincronizarRespostaAsyncAction = AsyncAction(
      '_ProvaRespostaStoreBase.sincronizarResposta',
      context: context);

  @override
  Future sincronizarResposta({bool force = false}) {
    return _$sincronizarRespostaAsyncAction
        .run(() => super.sincronizarResposta(force: force));
  }

  late final _$definirRespostaAsyncAction =
      AsyncAction('_ProvaRespostaStoreBase.definirResposta', context: context);

  @override
  Future<void> definirResposta(int questaoId,
      {int? alternativaId, String? textoResposta, int tempoQuestao = 0}) {
    return _$definirRespostaAsyncAction.run(() => super.definirResposta(
        questaoId,
        alternativaId: alternativaId,
        textoResposta: textoResposta,
        tempoQuestao: tempoQuestao));
  }

  late final _$definirTempoRespostaAsyncAction = AsyncAction(
      '_ProvaRespostaStoreBase.definirTempoResposta',
      context: context);

  @override
  Future<void> definirTempoResposta(int questaoId, {int tempoQuestao = 0}) {
    return _$definirTempoRespostaAsyncAction.run(() =>
        super.definirTempoResposta(questaoId, tempoQuestao: tempoQuestao));
  }

  @override
  String toString() {
    return '''
idProva: ${idProva},
codigoEOL: ${codigoEOL},
respostasLocal: ${respostasLocal}
    ''';
  }
}
