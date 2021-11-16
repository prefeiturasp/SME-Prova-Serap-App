import 'package:flutter/widgets.dart';

class OrientacaoInicialModel {
  Widget? imagem;
  String? titulo;
  String? descricao;
  Widget? corpoPersonalizado;
  bool ehHTML;

  OrientacaoInicialModel({this.imagem, this.titulo, this.descricao, this.corpoPersonalizado, this.ehHTML = false});
}
