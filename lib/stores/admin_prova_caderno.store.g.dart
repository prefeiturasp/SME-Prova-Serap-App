// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova_caderno.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdminProvaCadernoViewStore on _AdminProvaCadernoViewStoreBase, Store {
  late final _$carregandoAtom = Atom(
      name: '_AdminProvaCadernoViewStoreBase.carregando', context: context);

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

  late final _$cadernosAtom =
      Atom(name: '_AdminProvaCadernoViewStoreBase.cadernos', context: context);

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

  late final _$carregarCadernosAsyncAction = AsyncAction(
      '_AdminProvaCadernoViewStoreBase.carregarCadernos',
      context: context);

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
