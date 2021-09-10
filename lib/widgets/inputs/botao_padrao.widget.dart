import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';

class BotaoPadraoWidget extends StatelessWidget {
  final String textoBotao;
  final double largura;
  final Function()? onPressed;

  BotaoPadraoWidget(
      {required this.textoBotao, required this.largura, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: this.onPressed,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Container(
          width: this.largura,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: TemaUtil.laranja01,
          ),
          child: Center(
            child: Text(
              this.textoBotao,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TemaUtil.branco,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
