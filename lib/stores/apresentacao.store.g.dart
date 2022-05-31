// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apresentacao.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ApresentacaoStore on _ApresentacaoStoreBase, Store {
  final _$paginaAtom = Atom(name: '_ApresentacaoStoreBase.pagina');

  @override
  int get pagina {
    _$paginaAtom.reportRead();
    return super.pagina;
  }

  @override
  set pagina(int value) {
    _$paginaAtom.reportWrite(value, super.pagina, () {
      super.pagina = value;
    });
  }

  @override
  String toString() {
    return '''
pagina: ${pagina}
    ''';
  }
}
