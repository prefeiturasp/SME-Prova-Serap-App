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

  late final _$responseAtom =
      Atom(name: '_QuestaoTaiViewStoreBase.response', context: context);

  @override
  QuestaoCompletaResponseDTO? get response {
    _$responseAtom.reportRead();
    return super.response;
  }

  @override
  set response(QuestaoCompletaResponseDTO? value) {
    _$responseAtom.reportWrite(value, super.response, () {
      super.response = value;
    });
  }

  late final _$carregarQuestaoAsyncAction =
      AsyncAction('_QuestaoTaiViewStoreBase.carregarQuestao', context: context);

  @override
  Future<dynamic> carregarQuestao(int provaId) {
    return _$carregarQuestaoAsyncAction
        .run(() => super.carregarQuestao(provaId));
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
provaStore: ${provaStore},
response: ${response}
    ''';
  }
}
