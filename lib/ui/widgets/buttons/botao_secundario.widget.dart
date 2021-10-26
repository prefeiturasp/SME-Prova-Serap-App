import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class BotaoSecundarioWidget extends StatelessWidget {
  final String textoBotao;
  final double? largura;
  final Function()? onPressed;
  final Color corDoTexto;

  final temaStore = GetIt.I.get<TemaStore>();

  BotaoSecundarioWidget({
    required this.textoBotao,
    this.largura,
    this.onPressed,
    this.corDoTexto = TemaUtil.pretoSemFoco,
  });

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
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          padding: MaterialStateProperty.all(
            EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
        ),
        child: Center(
          child: Observer(
            builder: (_) {
              return Text(
                textoBotao,
                textAlign: TextAlign.center,
                style: TemaUtil.temaTextoBotaoSecundario.copyWith(
                  color: corDoTexto,
                  fontSize: temaStore.tTexto16,
                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
