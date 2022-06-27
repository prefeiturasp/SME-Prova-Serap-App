// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProvaStore on _ProvaStoreBase, Store {
  final _$conexaoStreamAtom = Atom(name: '_ProvaStoreBase.conexaoStream');

  @override
  ObservableStream<ConnectivityStatus> get conexaoStream {
    _$conexaoStreamAtom.reportRead();
    return super.conexaoStream;
  }

  @override
  set conexaoStream(ObservableStream<ConnectivityStatus> value) {
    _$conexaoStreamAtom.reportWrite(value, super.conexaoStream, () {
      super.conexaoStream = value;
    });
  }

  final _$isVisibleAtom = Atom(name: '_ProvaStoreBase.isVisible');

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

  final _$provaAtom = Atom(name: '_ProvaStoreBase.prova');

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

  final _$downloadStatusAtom = Atom(name: '_ProvaStoreBase.downloadStatus');

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

  final _$tempoCorrendoAtom = Atom(name: '_ProvaStoreBase.tempoCorrendo');

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

  final _$statusAtom = Atom(name: '_ProvaStoreBase.status');

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

  final _$tempoPrevistoAtom = Atom(name: '_ProvaStoreBase.tempoPrevisto');

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

  final _$progressoDownloadAtom =
      Atom(name: '_ProvaStoreBase.progressoDownload');

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

  final _$iconeAtom = Atom(name: '_ProvaStoreBase.icone');

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

  final _$codigoIniciarProvaAtom =
      Atom(name: '_ProvaStoreBase.codigoIniciarProva');

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

  final _$tempoExecucaoStoreAtom =
      Atom(name: '_ProvaStoreBase.tempoExecucaoStore');

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

  final _$inicioQuestaoAtom = Atom(name: '_ProvaStoreBase.inicioQuestao');

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

  final _$fimQuestaoAtom = Atom(name: '_ProvaStoreBase.fimQuestao');

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

  final _$iniciarDownloadAsyncAction =
      AsyncAction('_ProvaStoreBase.iniciarDownload');

  @override
  Future iniciarDownload() {
    return _$iniciarDownloadAsyncAction.run(() => super.iniciarDownload());
  }

  final _$_onRespondendoProvaChangeAsyncAction =
      AsyncAction('_ProvaStoreBase._onRespondendoProvaChange');

  @override
  Future _onRespondendoProvaChange(bool isRepondendoProva) {
    return _$_onRespondendoProvaChangeAsyncAction
        .run(() => super._onRespondendoProvaChange(isRepondendoProva));
  }

  final _$onChangeConexaoAsyncAction =
      AsyncAction('_ProvaStoreBase.onChangeConexao');

  @override
  Future<dynamic> onChangeConexao(ConnectivityStatus? resultado) {
    return _$onChangeConexaoAsyncAction
        .run(() => super.onChangeConexao(resultado));
  }

  final _$iniciarProvaAsyncAction = AsyncAction('_ProvaStoreBase.iniciarProva');

  @override
  Future iniciarProva() {
    return _$iniciarProvaAsyncAction.run(() => super.iniciarProva());
  }

  final _$continuarProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.continuarProva');

  @override
  Future continuarProva() {
    return _$continuarProvaAsyncAction.run(() => super.continuarProva());
  }

  final _$configurarProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.configurarProva');

  @override
  Future configurarProva() {
    return _$configurarProvaAsyncAction.run(() => super.configurarProva());
  }

  final _$setStatusProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.setStatusProva');

  @override
  Future setStatusProva(EnumProvaStatus provaStatus) {
    return _$setStatusProvaAsyncAction
        .run(() => super.setStatusProva(provaStatus));
  }

  final _$finalizarProvaAsyncAction =
      AsyncAction('_ProvaStoreBase.finalizarProva');

  @override
  Future<bool> finalizarProva([bool automaticamente = false]) {
    return _$finalizarProvaAsyncAction
        .run(() => super.finalizarProva(automaticamente));
  }

  final _$removerDownloadAsyncAction =
      AsyncAction('_ProvaStoreBase.removerDownload');

  @override
  Future removerDownload() {
    return _$removerDownloadAsyncAction.run(() => super.removerDownload());
  }

  final _$_ProvaStoreBaseActionController =
      ActionController(name: '_ProvaStoreBase');

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
conexaoStream: ${conexaoStream},
isVisible: ${isVisible},
prova: ${prova},
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
