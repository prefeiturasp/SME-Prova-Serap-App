// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.admin.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeAdminStore on _HomeAdminStoreBase, Store {
  final _$carregandoAtom = Atom(name: '_HomeAdminStoreBase.carregando');

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

  final _$codigoIniciarProvaAtom =
      Atom(name: '_HomeAdminStoreBase.codigoIniciarProva');

  @override
  String get codigoIniciarProva {
    _$codigoIniciarProvaAtom.reportRead();
    return super.codigoIniciarProva;
  }

  @override
  set codigoIniciarProva(String value) {
    _$codigoIniciarProvaAtom.reportWrite(value, super.codigoIniciarProva, () {
      super.codigoIniciarProva = value;
    });
  }

  final _$codigoSerapAtom = Atom(name: '_HomeAdminStoreBase.codigoSerap');

  @override
  String? get codigoSerap {
    _$codigoSerapAtom.reportRead();
    return super.codigoSerap;
  }

  @override
  set codigoSerap(String? value) {
    _$codigoSerapAtom.reportWrite(value, super.codigoSerap, () {
      super.codigoSerap = value;
    });
  }

  final _$desricaoAtom = Atom(name: '_HomeAdminStoreBase.desricao');

  @override
  String? get desricao {
    _$desricaoAtom.reportRead();
    return super.desricao;
  }

  @override
  set desricao(String? value) {
    _$desricaoAtom.reportWrite(value, super.desricao, () {
      super.desricao = value;
    });
  }

  final _$modalidadeAtom = Atom(name: '_HomeAdminStoreBase.modalidade');

  @override
  ModalidadeEnum? get modalidade {
    _$modalidadeAtom.reportRead();
    return super.modalidade;
  }

  @override
  set modalidade(ModalidadeEnum? value) {
    _$modalidadeAtom.reportWrite(value, super.modalidade, () {
      super.modalidade = value;
    });
  }

  final _$anoAtom = Atom(name: '_HomeAdminStoreBase.ano');

  @override
  String? get ano {
    _$anoAtom.reportRead();
    return super.ano;
  }

  @override
  set ano(String? value) {
    _$anoAtom.reportWrite(value, super.ano, () {
      super.ano = value;
    });
  }

  final _$provasAtom = Atom(name: '_HomeAdminStoreBase.provas');

  @override
  ObservableList<AdminProvaResponseDTO> get provas {
    _$provasAtom.reportRead();
    return super.provas;
  }

  @override
  set provas(ObservableList<AdminProvaResponseDTO> value) {
    _$provasAtom.reportWrite(value, super.provas, () {
      super.provas = value;
    });
  }

  final _$carregarProvasAsyncAction =
      AsyncAction('_HomeAdminStoreBase.carregarProvas');

  @override
  Future carregarProvas({bool? refresh}) {
    return _$carregarProvasAsyncAction
        .run(() => super.carregarProvas(refresh: refresh));
  }

  final _$filtrarAsyncAction = AsyncAction('_HomeAdminStoreBase.filtrar');

  @override
  Future filtrar() {
    return _$filtrarAsyncAction.run(() => super.filtrar());
  }

  final _$_HomeAdminStoreBaseActionController =
      ActionController(name: '_HomeAdminStoreBase');

  @override
  dynamic limparFiltros() {
    final _$actionInfo = _$_HomeAdminStoreBaseActionController.startAction(
        name: '_HomeAdminStoreBase.limparFiltros');
    try {
      return super.limparFiltros();
    } finally {
      _$_HomeAdminStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
codigoIniciarProva: ${codigoIniciarProva},
codigoSerap: ${codigoSerap},
desricao: ${desricao},
modalidade: ${modalidade},
ano: ${ano},
provas: ${provas}
    ''';
  }
}
