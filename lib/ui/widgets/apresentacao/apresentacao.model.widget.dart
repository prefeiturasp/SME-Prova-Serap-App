import 'package:flutter/widgets.dart';

class ApresentacaoModelWidget {
  Widget? imagem;
  String? titulo;
  String? descricao;
  Widget? corpoPersonalizado;
  bool ehHTML;

  ApresentacaoModelWidget({
    this.imagem,
    this.titulo,
    this.descricao,
    this.corpoPersonalizado,
    this.ehHTML = false,
  });
}
