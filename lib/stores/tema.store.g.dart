// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tema.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TemaStore on _TemaStoreBase, Store {
  late final _$incrementadorAtom =
      Atom(name: '_TemaStoreBase.incrementador', context: context);

  @override
  double get incrementador {
    _$incrementadorAtom.reportRead();
    return super.incrementador;
  }

  @override
  set incrementador(double value) {
    _$incrementadorAtom.reportWrite(value, super.incrementador, () {
      super.incrementador = value;
    });
  }

  late final _$tTexto10Atom =
      Atom(name: '_TemaStoreBase.tTexto10', context: context);

  @override
  double get tTexto10 {
    _$tTexto10Atom.reportRead();
    return super.tTexto10;
  }

  @override
  set tTexto10(double value) {
    _$tTexto10Atom.reportWrite(value, super.tTexto10, () {
      super.tTexto10 = value;
    });
  }

  late final _$tTexto12Atom =
      Atom(name: '_TemaStoreBase.tTexto12', context: context);

  @override
  double get tTexto12 {
    _$tTexto12Atom.reportRead();
    return super.tTexto12;
  }

  @override
  set tTexto12(double value) {
    _$tTexto12Atom.reportWrite(value, super.tTexto12, () {
      super.tTexto12 = value;
    });
  }

  late final _$tTexto14Atom =
      Atom(name: '_TemaStoreBase.tTexto14', context: context);

  @override
  double get tTexto14 {
    _$tTexto14Atom.reportRead();
    return super.tTexto14;
  }

  @override
  set tTexto14(double value) {
    _$tTexto14Atom.reportWrite(value, super.tTexto14, () {
      super.tTexto14 = value;
    });
  }

  late final _$tTexto16Atom =
      Atom(name: '_TemaStoreBase.tTexto16', context: context);

  @override
  double get tTexto16 {
    _$tTexto16Atom.reportRead();
    return super.tTexto16;
  }

  @override
  set tTexto16(double value) {
    _$tTexto16Atom.reportWrite(value, super.tTexto16, () {
      super.tTexto16 = value;
    });
  }

  late final _$tTexto18Atom =
      Atom(name: '_TemaStoreBase.tTexto18', context: context);

  @override
  double get tTexto18 {
    _$tTexto18Atom.reportRead();
    return super.tTexto18;
  }

  @override
  set tTexto18(double value) {
    _$tTexto18Atom.reportWrite(value, super.tTexto18, () {
      super.tTexto18 = value;
    });
  }

  late final _$tTexto20Atom =
      Atom(name: '_TemaStoreBase.tTexto20', context: context);

  @override
  double get tTexto20 {
    _$tTexto20Atom.reportRead();
    return super.tTexto20;
  }

  @override
  set tTexto20(double value) {
    _$tTexto20Atom.reportWrite(value, super.tTexto20, () {
      super.tTexto20 = value;
    });
  }

  late final _$tTexto24Atom =
      Atom(name: '_TemaStoreBase.tTexto24', context: context);

  @override
  double get tTexto24 {
    _$tTexto24Atom.reportRead();
    return super.tTexto24;
  }

  @override
  set tTexto24(double value) {
    _$tTexto24Atom.reportWrite(value, super.tTexto24, () {
      super.tTexto24 = value;
    });
  }

  late final _$fonteDoTextoAtom =
      Atom(name: '_TemaStoreBase.fonteDoTexto', context: context);

  @override
  FonteTipoEnum get fonteDoTexto {
    _$fonteDoTextoAtom.reportRead();
    return super.fonteDoTexto;
  }

  @override
  set fonteDoTexto(FonteTipoEnum value) {
    _$fonteDoTextoAtom.reportWrite(value, super.fonteDoTexto, () {
      super.fonteDoTexto = value;
    });
  }

  late final _$_TemaStoreBaseActionController =
      ActionController(name: '_TemaStoreBase', context: context);

  @override
  void fachadaAlterarTamanhoDoTexto(double valor, {bool update = true}) {
    final _$actionInfo = _$_TemaStoreBaseActionController.startAction(
        name: '_TemaStoreBase.fachadaAlterarTamanhoDoTexto');
    try {
      return super.fachadaAlterarTamanhoDoTexto(valor, update: update);
    } finally {
      _$_TemaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void mudarFonte(FonteTipoEnum fonte, {bool update = true}) {
    final _$actionInfo = _$_TemaStoreBaseActionController.startAction(
        name: '_TemaStoreBase.mudarFonte');
    try {
      return super.mudarFonte(fonte, update: update);
    } finally {
      _$_TemaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
incrementador: ${incrementador},
tTexto10: ${tTexto10},
tTexto12: ${tTexto12},
tTexto14: ${tTexto14},
tTexto16: ${tTexto16},
tTexto18: ${tTexto18},
tTexto20: ${tTexto20},
tTexto24: ${tTexto24},
fonteDoTexto: ${fonteDoTexto}
    ''';
  }
}
