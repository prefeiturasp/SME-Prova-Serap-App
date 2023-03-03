// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProvaStore on _ProvaStoreBase, Store {
  late final _$isVisibleAtom =
      Atom(name: '_ProvaStoreBase.isVisible', context: context);

  @override
  bool get isVisible {
    _$isVisibleAtom.reportRead();
    return super.isVisible;
  }

  @override
  set isVisible(bool value) {
    _$isVisibleAtom.reportWrite(value, super.isVisible, () {
      super.isVisible = value;
    });
  }

  late final _$provaAtom =
      Atom(name: '_ProvaStoreBase.prova', context: context);

  @override
  Prova get prova {
    _$provaAtom.reportRead();
    return super.prova;
  }

  @override
  set prova(Prova value) {
    _$provaAtom.reportWrite(value, super.prova, () {
      super.prova = value;
    });
  }

  late final _$tratamentoImagemAtom =
      Atom(name: '_ProvaStoreBase.tratamentoImagem', context: context);

  @override
  TratamentoImagemEnum get tratamentoImagem {
    _$tratamentoImagemAtom.reportRead();
    return super.tratamentoImagem;
  }

  @override
  set tratamentoImagem(TratamentoImagemEnum value) {
    _$tratamentoImagemAtom.reportWrite(value, super.tratamentoImagem, () {
      super.tratamentoImagem = value;
    });
  }

  late final _$downloadStatusAtom =
      Atom(name: '_ProvaStoreBase.downloadStatus', context: context);

  @override
  EnumDownloadStatus get downloadStatus {
    _$downloadStatusAtom.reportRead();
    return super.downloadStatus;
  }

  @override
  set downloadStatus(EnumDownloadStatus value) {
    _$downloadStatusAtom.reportWrite(value, super.downloadStatus, () {
      super.downloadStatus = value;
    });
  }

  late final _$tempoCorrendoAtom =
      Atom(name: '_ProvaStoreBase.tempoCorrendo', context: context);

  @override
  EnumTempoStatus get tempoCorrendo {
    _$tempoCorrendoAtom.reportRead();
    return super.tempoCorrendo;
  }

  @override
  set tempoCorrendo(EnumTempoStatus value) {
    _$tempoCorrendoAtom.reportWrite(value, super.tempoCorrendo, () {
      super.tempoCorrendo = value;
    });
  }

  late final _$statusAtom =
      Atom(name: '_ProvaStoreBase.status', context: context);

  @override
  EnumProvaStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(EnumProvaStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$tempoPrevistoAtom =
      Atom(name: '_ProvaStoreBase.tempoPrevisto', context: context);

  @override
  double get tempoPrevisto {
    _$tempoPrevistoAtom.reportRead();
    return super.tempoPrevisto;
  }

  @override
  set tempoPrevisto(double value) {
    _$tempoPrevistoAtom.reportWrite(value, super.tempoPrevisto, () {
      super.tempoPrevisto = value;
    });
  }

  late final _$progressoDownloadAtom =
      Atom(name: '_ProvaStoreBase.progressoDownload', context: context);

  @override
  double get progressoDownload {
    _$progressoDownloadAtom.reportRead();
    return super.progressoDownload;
  }

  @override
  set progressoDownload(double value) {
    _$progressoDownloadAtom.reportWrite(value, super.progressoDownload, () {
      super.progressoDownload = value;
    });
  }

  late final _$iconeAtom =
      Atom(name: '_ProvaStoreBase.icone', context: context);

  @override
  String get icone {
    _$iconeAtom.reportRead();
    return super.icone;
  }

  @override
  set icone(String value) {
    _$iconeAtom.reportWrite(value, super.icone, () {
      super.icone = value;
    });
  }

  late final _$codigoIniciarProvaAtom =
      Atom(name: '_ProvaStoreBase.codigoIniciarProva', context: context);

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

  late final _$tempoExecucaoStoreAtom =
      Atom(name: '_ProvaStoreBase.tempoExecucaoStore', context: context);

  @override
  ProvaTempoExecucaoStore? get tempoExecucaoStore {
    _$tempoExecucaoStoreAtom.reportRead();
    return super.tempoExecucaoStore;
  }

  @override
  set tempoExecucaoStore(ProvaTempoExecucaoStore? value) {
    _$tempoExecucaoStoreAtom.reportWrite(value, super.tempoExecucaoStore, () {
      super.tempoExecucaoStore = value;
    });
  }

  late final _$inicioQuestaoAtom =
      Atom(name: '_ProvaStoreBase.inicioQuestao', context: context);

  @override
  DateTime get inicioQuestao {
    _$inicioQuestaoAtom.reportRead();
    return super.inicioQuestao;
  }

  @override
  set inicioQuestao(DateTime value) {
    _$inicioQuestaoAtom.reportWrite(value, super.inicioQuestao, () {
      super.inicioQuestao = value;
    });
  }

  late final _$fimQuestaoAtom =
      Atom(name: '_ProvaStoreBase.fimQuestao', context: context);

  @override
  DateTime get fimQuestao {
    _$fimQuestaoAtom.reportRead();
    return super.fimQuestao;
  }

  @override
  set fimQuestao(DateTime value) {
    _$fimQuestaoAtom.reportWrite(value, super.fimQuestao, () {
      super.fimQuestao = value;
    });
  }

  late final _$iniciarDownloadAsyncAction =
      AsyncAction('_ProvaStoreBase.iniciarDownload', context: context);

  @override
  Future iniciarDownload() {
    return _$iniciarDownloadAsyncAction.run(() => super.iniciarDownload());
  }

  late final _$_onRespondendoProvaChangeAsyncAction = AsyncAction(
      '_ProvaStoreBase._onRespondendoProvaChange',
      context: context);

  @override
  Future _onRespondendoProvaChange(bool isRepondendoProva) {
    return _$_onRespondendoProvaChangeAsyncAction
        .run(() => super._onRespondendoProvaChange(isRepondendoProva));
  }

  late final _$onChangeConexaoAsyncAction =
      AsyncAction('_ProvaStoreBase.onChangeConexao', context: context);

  @override
  Future<dynamic> onChangeConexao(bool temConexao) {
    return _$onChangeConexaoAsyncAction
        .run(() => super.onChangeConexao(temConexao));
  }

  late final _$iniciarProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.iniciarProva', context: context);

  @override
  Future iniciarProva() {
    return _$iniciarProvaAsyncAction.run(() => super.iniciarProva());
  }

  late final _$continuarProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.continuarProva', context: context);

  @override
  Future continuarProva() {
    return _$continuarProvaAsyncAction.run(() => super.continuarProva());
  }

  late final _$configurarProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.configurarProva', context: context);

  @override
  Future configurarProva() {
    return _$configurarProvaAsyncAction.run(() => super.configurarProva());
  }

  late final _$setStatusProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.setStatusProva', context: context);

  @override
  Future setStatusProva(EnumProvaStatus provaStatus) {
    return _$setStatusProvaAsyncAction
        .run(() => super.setStatusProva(provaStatus));
  }

  late final _$setHoraFimProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.setHoraFimProva', context: context);

  @override
  Future<int> setHoraFimProva(DateTime dataFimProvaAluno) {
    return _$setHoraFimProvaAsyncAction
        .run(() => super.setHoraFimProva(dataFimProvaAluno));
  }

  late final _$setHoraInicioProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.setHoraInicioProva', context: context);

  @override
  Future<int> setHoraInicioProva(DateTime dataInicioProvaAluno) {
    return _$setHoraInicioProvaAsyncAction
        .run(() => super.setHoraInicioProva(dataInicioProvaAluno));
  }

  late final _$finalizarProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.finalizarProva', context: context);

  @override
  Future<bool> finalizarProva([bool automaticamente = false]) {
    return _$finalizarProvaAsyncAction
        .run(() => super.finalizarProva(automaticamente));
  }

  late final _$removerDownloadAsyncAction =
      AsyncAction('_ProvaStoreBase.removerDownload', context: context);

  @override
  Future removerDownload([bool manterRegistroProva = false]) {
    return _$removerDownloadAsyncAction
        .run(() => super.removerDownload(manterRegistroProva));
  }

  late final _$_ProvaStoreBaseActionController =
      ActionController(name: '_ProvaStoreBase', context: context);

  @override
  dynamic setRespondendoProva(bool value) {
    final _$actionInfo = _$_ProvaStoreBaseActionController.startAction(
        name: '_ProvaStoreBase.setRespondendoProva');
    try {
      return super.setRespondendoProva(value);
    } finally {
      _$_ProvaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic configure() {
    final _$actionInfo = _$_ProvaStoreBaseActionController.startAction(
        name: '_ProvaStoreBase.configure');
    try {
      return super.configure();
    } finally {
      _$_ProvaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic onChangeContadorQuestao(EnumTempoStatus finalizado) {
    final _$actionInfo = _$_ProvaStoreBaseActionController.startAction(
        name: '_ProvaStoreBase.onChangeContadorQuestao');
    try {
      return super.onChangeContadorQuestao(finalizado);
    } finally {
      _$_ProvaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic onStatusChange(EnumDownloadStatus statusDownload) {
    final _$actionInfo = _$_ProvaStoreBaseActionController.startAction(
        name: '_ProvaStoreBase.onStatusChange');
    try {
      return super.onStatusChange(statusDownload);
    } finally {
      _$_ProvaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic _configurarTempoExecucao() {
    final _$actionInfo = _$_ProvaStoreBaseActionController.startAction(
        name: '_ProvaStoreBase._configurarTempoExecucao');
    try {
      return super._configurarTempoExecucao();
    } finally {
      _$_ProvaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isVisible: ${isVisible},
prova: ${prova},
tratamentoImagem: ${tratamentoImagem},
downloadStatus: ${downloadStatus},
tempoCorrendo: ${tempoCorrendo},
status: ${status},
tempoPrevisto: ${tempoPrevisto},
progressoDownload: ${progressoDownload},
icone: ${icone},
codigoIniciarProva: ${codigoIniciarProva},
tempoExecucaoStore: ${tempoExecucaoStore},
inicioQuestao: ${inicioQuestao},
fimQuestao: ${fimQuestao}
    ''';
  }
}
