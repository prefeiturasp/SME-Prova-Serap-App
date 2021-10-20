import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
    return SizedBox(
      height: 50,
      width: largura,
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
            EdgeInsets.fromLTRB(20, 0, 20, 0),
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
      return Observer(
        builder: (_) {
          return Text(
            textoBotao!,
            textAlign: TextAlign.center,
            style: TemaUtil.temaTextoBotao.copyWith(
              fontSize: temaStore.tTexto16,
            ),
          );
        },
      );
    }

    return child;
  }
}
