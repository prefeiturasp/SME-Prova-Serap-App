import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class BotaoTercearioWidget extends StatelessWidget {
  final String? textoBotao;
  final Widget? child;
  final double? largura;
  final bool desabilitado;
  final Function()? onPressed;
  // final BuildContext context;

  final temaStore = GetIt.I.get<TemaStore>();

  BotaoTercearioWidget({
    this.textoBotao,
    this.largura,
    this.onPressed,
    this.child,
    this.desabilitado = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      constraints: BoxConstraints(minHeight: 40),
      child: OutlinedButton(
        onPressed: desabilitado ? null : onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(color: TemaUtil.azul02, width: 1.0, style: BorderStyle.solid),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 8, vertical: kIsMobile ? 8 : 8),
          ),
        ),
        child: Center(
          child: _buildChild(),
        ),
      ),
    );
  }

  _buildChild() {
    if (textoBotao != null) {
      return Texto(
        textoBotao!,
        center: true,
        color: TemaUtil.azul02,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        maxLines: 2,
      );
    }

    return child;
  }
}
