// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova_questao.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AdminProvaQuestaoViewStore on _AdminProvaQuestaoViewStoreBase, Store {
  final _$carregandoAtom =
      Atom(name: '_AdminProvaQuestaoViewStoreBase.carregando');

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

  final _$detalhesAtom = Atom(name: '_AdminProvaQuestaoViewStoreBase.detalhes');

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

  final _$questaoAtom = Atom(name: '_AdminProvaQuestaoViewStoreBase.questao');

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

  final _$carregarDetalhesQuestaoAsyncAction =
      AsyncAction('_AdminProvaQuestaoViewStoreBase.carregarDetalhesQuestao');

  @override
  Future<void> carregarDetalhesQuestao(int idProva, int idQuestao) {
    return _$carregarDetalhesQuestaoAsyncAction
        .run(() => super.carregarDetalhesQuestao(idProva, idQuestao));
  }

  final _$carregarDetalhesAsyncAction =
      AsyncAction('_AdminProvaQuestaoViewStoreBase.carregarDetalhes');

  @override
  Future carregarDetalhes() {
    return _$carregarDetalhesAsyncAction.run(() => super.carregarDetalhes());
  }

  final _$_AdminProvaQuestaoViewStoreBaseActionController =
      ActionController(name: '_AdminProvaQuestaoViewStoreBase');

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
detalhes: ${detalhes},
questao: ${questao}
    ''';
  }
}
