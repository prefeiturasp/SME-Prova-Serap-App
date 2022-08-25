// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_tempo_exeucao.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProvaTempoExecucaoStore on _ProvaTempoExecucaoStoreBase, Store {
  Computed<bool>? _$isTempoNormalEmExecucaoComputed;

  @override
  bool get isTempoNormalEmExecucao => (_$isTempoNormalEmExecucaoComputed ??=
          Computed<bool>(() => super.isTempoNormalEmExecucao,
              name: '_ProvaTempoExecucaoStoreBase.isTempoNormalEmExecucao'))
      .value;
  Computed<bool>? _$isTempoExtendidoComputed;

  @override
  bool get isTempoExtendido => (_$isTempoExtendidoComputed ??= Computed<bool>(
          () => super.isTempoExtendido,
          name: '_ProvaTempoExecucaoStoreBase.isTempoExtendido'))
      .value;
  Computed<bool>? _$possuiTempoRestanteComputed;

  @override
  bool get possuiTempoRestante => (_$possuiTempoRestanteComputed ??=
          Computed<bool>(() => super.possuiTempoRestante,
              name: '_ProvaTempoExecucaoStoreBase.possuiTempoRestante'))
      .value;

  late final _$statusAtom =
      Atom(name: '_ProvaTempoExecucaoStoreBase.status', context: context);

  @override
  EnumProvaTempoEventType get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(EnumProvaTempoEventType value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$porcentagemAtom =
      Atom(name: '_ProvaTempoExecucaoStoreBase.porcentagem', context: context);

  @override
  double get porcentagem {
    _$porcentagemAtom.reportRead();
    return super.porcentagem;
  }

  @override
  set porcentagem(double value) {
    _$porcentagemAtom.reportWrite(value, super.porcentagem, () {
      super.porcentagem = value;
    });
  }

  late final _$horaFinalTurnoAtom = Atom(
      name: '_ProvaTempoExecucaoStoreBase.horaFinalTurno', context: context);

  @override
  int get horaFinalTurno {
    _$horaFinalTurnoAtom.reportRead();
    return super.horaFinalTurno;
  }

  @override
  set horaFinalTurno(int value) {
    _$horaFinalTurnoAtom.reportWrite(value, super.horaFinalTurno, () {
      super.horaFinalTurno = value;
    });
  }

  late final _$tempoRestanteAtom = Atom(
      name: '_ProvaTempoExecucaoStoreBase.tempoRestante', context: context);

  @override
  Duration get tempoRestante {
    _$tempoRestanteAtom.reportRead();
    return super.tempoRestante;
  }

  @override
  set tempoRestante(Duration value) {
    _$tempoRestanteAtom.reportWrite(value, super.tempoRestante, () {
      super.tempoRestante = value;
    });
  }

  late final _$tempoAcabandoAtom = Atom(
      name: '_ProvaTempoExecucaoStoreBase.tempoAcabando', context: context);

  @override
  bool get tempoAcabando {
    _$tempoAcabandoAtom.reportRead();
    return super.tempoAcabando;
  }

  @override
  set tempoAcabando(bool value) {
    _$tempoAcabandoAtom.reportWrite(value, super.tempoAcabando, () {
      super.tempoAcabando = value;
    });
  }

  late final _$mostrarAlertaDeTempoAcabandoAtom = Atom(
      name: '_ProvaTempoExecucaoStoreBase.mostrarAlertaDeTempoAcabando',
      context: context);

  @override
  bool get mostrarAlertaDeTempoAcabando {
    _$mostrarAlertaDeTempoAcabandoAtom.reportRead();
    return super.mostrarAlertaDeTempoAcabando;
  }

  @override
  set mostrarAlertaDeTempoAcabando(bool value) {
    _$mostrarAlertaDeTempoAcabandoAtom
        .reportWrite(value, super.mostrarAlertaDeTempoAcabando, () {
      super.mostrarAlertaDeTempoAcabando = value;
    });
  }

  late final _$_ProvaTempoExecucaoStoreBaseActionController =
      ActionController(name: '_ProvaTempoExecucaoStoreBase', context: context);

  @override
  dynamic iniciarContador(DateTime dataHoraInicioProva) {
    final _$actionInfo = _$_ProvaTempoExecucaoStoreBaseActionController
        .startAction(name: '_ProvaTempoExecucaoStoreBase.iniciarContador');
    try {
      return super.iniciarContador(dataHoraInicioProva);
    } finally {
      _$_ProvaTempoExecucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic configure() {
    final _$actionInfo = _$_ProvaTempoExecucaoStoreBaseActionController
        .startAction(name: '_ProvaTempoExecucaoStoreBase.configure');
    try {
      return super.configure();
    } finally {
      _$_ProvaTempoExecucaoStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
porcentagem: ${porcentagem},
horaFinalTurno: ${horaFinalTurno},
tempoRestante: ${tempoRestante},
tempoAcabando: ${tempoAcabando},
mostrarAlertaDeTempoAcabando: ${mostrarAlertaDeTempoAcabando},
isTempoNormalEmExecucao: ${isTempoNormalEmExecucao},
isTempoExtendido: ${isTempoExtendido},
possuiTempoRestante: ${possuiTempoRestante}
    ''';
  }
}
