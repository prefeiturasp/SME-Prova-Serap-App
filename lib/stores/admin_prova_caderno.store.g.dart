// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova_caderno.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AdminProvaCadernoViewStore on _AdminProvaCadernoViewStoreBase, Store {
  final _$carregandoAtom =
      Atom(name: '_AdminProvaCadernoViewStoreBase.carregando');

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

  final _$cadernosAtom = Atom(name: '_AdminProvaCadernoViewStoreBase.cadernos');

  @override
  ObservableList<String> get cadernos {
    _$cadernosAtom.reportRead();
    return super.cadernos;
  }

  @override
  set cadernos(ObservableList<String> value) {
    _$cadernosAtom.reportWrite(value, super.cadernos, () {
      super.cadernos = value;
    });
  }

  final _$carregarCadernosAsyncAction =
      AsyncAction('_AdminProvaCadernoViewStoreBase.carregarCadernos');

  @override
  Future carregarCadernos(int idProva) {
    return _$carregarCadernosAsyncAction
        .run(() => super.carregarCadernos(idProva));
  }

  @override
  String toString() {
    return '''
carregando: ${carregando},
cadernos: ${cadernos}
    ''';
  }
}
