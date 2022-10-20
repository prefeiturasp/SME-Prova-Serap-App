import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class BotaoDefaultWidget extends StatelessWidget {
  final String? textoBotao;
  final Widget? child;
  final double? largura;
  final bool desabilitado;
  final Function()? onPressed;
  // final BuildContext context;

  final temaStore = GetIt.I.get<TemaStore>();

  BotaoDefaultWidget({
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
      child: TextButton(
        onPressed: desabilitado ? null : onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // backgroundColor: MaterialStateProperty.all<Color>(TemaUtil.laranja01),
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 12, vertical: kIsMobile ? 8 : 12),
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
        color: Colors.white,
        fontSize: kIsMobile ? 14 : 16,
        fontWeight: FontWeight.w500,
        maxLines: 2,
      );
    }

    return child;
  }
}
