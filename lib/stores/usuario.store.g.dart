// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UsuarioStore on _UsuarioStoreBase, Store {
  Computed<bool>? _$isLogadoComputed;

  @override
  bool get isLogado =>
      (_$isLogadoComputed ??= Computed<bool>(() => super.isLogado,
              name: '_UsuarioStoreBase.isLogado'))
          .value;

  late final _$tokenAtom =
      Atom(name: '_UsuarioStoreBase.token', context: context);

  @override
  String? get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String? value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$tokenDataHoraExpiracaoAtom =
      Atom(name: '_UsuarioStoreBase.tokenDataHoraExpiracao', context: context);

  @override
  DateTime? get tokenDataHoraExpiracao {
    _$tokenDataHoraExpiracaoAtom.reportRead();
    return super.tokenDataHoraExpiracao;
  }

  @override
  set tokenDataHoraExpiracao(DateTime? value) {
    _$tokenDataHoraExpiracaoAtom
        .reportWrite(value, super.tokenDataHoraExpiracao, () {
      super.tokenDataHoraExpiracao = value;
    });
  }

  late final _$ultimoLoginAtom =
      Atom(name: '_UsuarioStoreBase.ultimoLogin', context: context);

  @override
  DateTime? get ultimoLogin {
    _$ultimoLoginAtom.reportRead();
    return super.ultimoLogin;
  }

  @override
  set ultimoLogin(DateTime? value) {
    _$ultimoLoginAtom.reportWrite(value, super.ultimoLogin, () {
      super.ultimoLogin = value;
    });
  }

  late final _$nomeAtom =
      Atom(name: '_UsuarioStoreBase.nome', context: context);

  @override
  String? get nome {
    _$nomeAtom.reportRead();
    return super.nome;
  }

  @override
  set nome(String? value) {
    _$nomeAtom.reportWrite(value, super.nome, () {
      super.nome = value;
    });
  }

  late final _$codigoEOLAtom =
      Atom(name: '_UsuarioStoreBase.codigoEOL', context: context);

  @override
  String? get codigoEOL {
    _$codigoEOLAtom.reportRead();
    return super.codigoEOL;
  }

  @override
  set codigoEOL(String? value) {
    _$codigoEOLAtom.reportWrite(value, super.codigoEOL, () {
      super.codigoEOL = value;
    });
  }

  late final _$anoAtom = Atom(name: '_UsuarioStoreBase.ano', context: context);

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

  late final _$tipoTurnoAtom =
      Atom(name: '_UsuarioStoreBase.tipoTurno', context: context);

  @override
  String? get tipoTurno {
    _$tipoTurnoAtom.reportRead();
    return super.tipoTurno;
  }

  @override
  set tipoTurno(String? value) {
    _$tipoTurnoAtom.reportWrite(value, super.tipoTurno, () {
      super.tipoTurno = value;
    });
  }

  late final _$tamanhoFonteAtom =
      Atom(name: '_UsuarioStoreBase.tamanhoFonte', context: context);

  @override
  double? get tamanhoFonte {
    _$tamanhoFonteAtom.reportRead();
    return super.tamanhoFonte;
  }

  @override
  set tamanhoFonte(double? value) {
    _$tamanhoFonteAtom.reportWrite(value, super.tamanhoFonte, () {
      super.tamanhoFonte = value;
    });
  }

  late final _$modalidadeAtom =
      Atom(name: '_UsuarioStoreBase.modalidade', context: context);

  @override
  ModalidadeEnum get modalidade {
    _$modalidadeAtom.reportRead();
    return super.modalidade;
  }

  @override
  set modalidade(ModalidadeEnum value) {
    _$modalidadeAtom.reportWrite(value, super.modalidade, () {
      super.modalidade = value;
    });
  }

  late final _$inicioTurnoAtom =
      Atom(name: '_UsuarioStoreBase.inicioTurno', context: context);

  @override
  int get inicioTurno {
    _$inicioTurnoAtom.reportRead();
    return super.inicioTurno;
  }

  @override
  set inicioTurno(int value) {
    _$inicioTurnoAtom.reportWrite(value, super.inicioTurno, () {
      super.inicioTurno = value;
    });
  }

  late final _$fimTurnoAtom =
      Atom(name: '_UsuarioStoreBase.fimTurno', context: context);

  @override
  int get fimTurno {
    _$fimTurnoAtom.reportRead();
    return super.fimTurno;
  }

  @override
  set fimTurno(int value) {
    _$fimTurnoAtom.reportWrite(value, super.fimTurno, () {
      super.fimTurno = value;
    });
  }

  late final _$dreAbreviacaoAtom =
      Atom(name: '_UsuarioStoreBase.dreAbreviacao', context: context);

  @override
  String? get dreAbreviacao {
    _$dreAbreviacaoAtom.reportRead();
    return super.dreAbreviacao;
  }

  @override
  set dreAbreviacao(String? value) {
    _$dreAbreviacaoAtom.reportWrite(value, super.dreAbreviacao, () {
      super.dreAbreviacao = value;
    });
  }

  late final _$escolaAtom =
      Atom(name: '_UsuarioStoreBase.escola', context: context);

  @override
  String? get escola {
    _$escolaAtom.reportRead();
    return super.escola;
  }

  @override
  set escola(String? value) {
    _$escolaAtom.reportWrite(value, super.escola, () {
      super.escola = value;
    });
  }

  late final _$turmaAtom =
      Atom(name: '_UsuarioStoreBase.turma', context: context);

  @override
  String? get turma {
    _$turmaAtom.reportRead();
    return super.turma;
  }

  @override
  set turma(String? value) {
    _$turmaAtom.reportWrite(value, super.turma, () {
      super.turma = value;
    });
  }

  late final _$familiaFonteAtom =
      Atom(name: '_UsuarioStoreBase.familiaFonte', context: context);

  @override
  FonteTipoEnum? get familiaFonte {
    _$familiaFonteAtom.reportRead();
    return super.familiaFonte;
  }

  @override
  set familiaFonte(FonteTipoEnum? value) {
    _$familiaFonteAtom.reportWrite(value, super.familiaFonte, () {
      super.familiaFonte = value;
    });
  }

  late final _$deficienciasAtom =
      Atom(name: '_UsuarioStoreBase.deficiencias', context: context);

  @override
  ObservableList<DeficienciaEnum> get deficiencias {
    _$deficienciasAtom.reportRead();
    return super.deficiencias;
  }

  @override
  set deficiencias(ObservableList<DeficienciaEnum> value) {
    _$deficienciasAtom.reportWrite(value, super.deficiencias, () {
      super.deficiencias = value;
    });
  }

  late final _$isRespondendoProvaAtom =
      Atom(name: '_UsuarioStoreBase.isRespondendoProva', context: context);

  @override
  bool get isRespondendoProva {
    _$isRespondendoProvaAtom.reportRead();
    return super.isRespondendoProva;
  }

  @override
  set isRespondendoProva(bool value) {
    _$isRespondendoProvaAtom.reportWrite(value, super.isRespondendoProva, () {
      super.isRespondendoProva = value;
    });
  }

  late final _$isAdminAtom =
      Atom(name: '_UsuarioStoreBase.isAdmin', context: context);

  @override
  bool get isAdmin {
    _$isAdminAtom.reportRead();
    return super.isAdmin;
  }

  @override
  set isAdmin(bool value) {
    _$isAdminAtom.reportWrite(value, super.isAdmin, () {
      super.isAdmin = value;
    });
  }

  late final _$carregarUsuarioAsyncAction =
      AsyncAction('_UsuarioStoreBase.carregarUsuario', context: context);

  @override
  Future<void> carregarUsuario() {
    return _$carregarUsuarioAsyncAction.run(() => super.carregarUsuario());
  }

  late final _$atualizarDadosAsyncAction =
      AsyncAction('_UsuarioStoreBase.atualizarDados', context: context);

  @override
  Future atualizarDados(
      {required String nome,
      String? codigoEOL,
      String? token,
      required String ano,
      required String tipoTurno,
      DateTime? ultimoLogin,
      required double tamanhoFonte,
      required FonteTipoEnum familiaFonte,
      required ModalidadeEnum modalidade,
      required int inicioTurno,
      required int fimTurno,
      required String dreAbreviacao,
      required String escola,
      required String turma,
      required List<DeficienciaEnum> deficiencias}) {
    return _$atualizarDadosAsyncAction.run(() => super.atualizarDados(
        nome: nome,
        codigoEOL: codigoEOL,
        token: token,
        ano: ano,
        tipoTurno: tipoTurno,
        ultimoLogin: ultimoLogin,
        tamanhoFonte: tamanhoFonte,
        familiaFonte: familiaFonte,
        modalidade: modalidade,
        inicioTurno: inicioTurno,
        fimTurno: fimTurno,
        dreAbreviacao: dreAbreviacao,
        escola: escola,
        turma: turma,
        deficiencias: deficiencias));
  }

  late final _$atualizarDadosAdmAsyncAction =
      AsyncAction('_UsuarioStoreBase.atualizarDadosAdm', context: context);

  @override
  Future<void> atualizarDadosAdm(
      {required String nome,
      required bool isAdmin,
      String? codigoEOL,
      String? token}) {
    return _$atualizarDadosAdmAsyncAction.run(() => super.atualizarDadosAdm(
        nome: nome, isAdmin: isAdmin, codigoEOL: codigoEOL, token: token));
  }

  late final _$_UsuarioStoreBaseActionController =
      ActionController(name: '_UsuarioStoreBase', context: context);

  @override
  void dispose() {
    final _$actionInfo = _$_UsuarioStoreBaseActionController.startAction(
        name: '_UsuarioStoreBase.dispose');
    try {
      return super.dispose();
    } finally {
      _$_UsuarioStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
token: ${token},
tokenDataHoraExpiracao: ${tokenDataHoraExpiracao},
ultimoLogin: ${ultimoLogin},
nome: ${nome},
codigoEOL: ${codigoEOL},
ano: ${ano},
tipoTurno: ${tipoTurno},
tamanhoFonte: ${tamanhoFonte},
modalidade: ${modalidade},
inicioTurno: ${inicioTurno},
fimTurno: ${fimTurno},
dreAbreviacao: ${dreAbreviacao},
escola: ${escola},
turma: ${turma},
familiaFonte: ${familiaFonte},
deficiencias: ${deficiencias},
isRespondendoProva: ${isRespondendoProva},
isAdmin: ${isAdmin},
isLogado: ${isLogado}
    ''';
  }
}
