import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';

class BotaoSecundario extends StatelessWidget {
  final String textoBotao;
  final double? largura;
  final Function()? onPressed;

  BotaoSecundario({required this.textoBotao, this.largura, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        width: largura,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            this.textoBotao,
            textAlign: TextAlign.center,
            style: TextStyle(color: TemaUtil.pretoSemFoco, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
