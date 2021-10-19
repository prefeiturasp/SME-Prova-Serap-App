import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';

class BotaoSecundarioWidget extends StatelessWidget {
  final String textoBotao;
  final double? largura;
  final Function()? onPressed;

  BotaoSecundarioWidget({required this.textoBotao, this.largura, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: largura,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // backgroundColor: MaterialStateProperty.all<Color>(TemaUtil.laranja01),
          padding: MaterialStateProperty.all(
            EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
        ),
        child: Center(
          child: Text(
            textoBotao,
            textAlign: TextAlign.center,
            style: TemaUtil.temaTextoBotaoSecundario,
          ),
        ),
      ),
    );
  }
}
