import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DialogDefaultWidget extends StatelessWidget {
  Widget? cabecalho;
  Widget? corpo;
  List<Widget> botoes = <Widget>[];
  String? mensagemOpcionalBotao;

  double? espacamentoHorizontal;
  double? espacamentoVertical;

  DialogDefaultWidget({
    this.cabecalho,
    this.corpo,
    this.botoes = const [],
    this.mensagemOpcionalBotao = "",
    this.espacamentoHorizontal = 100,
    this.espacamentoVertical = 300,
  }) {
    if(kIsWeb){
      espacamentoHorizontal = 300;
    }
  }

  @override
  Widget build(BuildContext context) {
    var posicaoBotao = MainAxisAlignment.center;
    if (botoes.isEmpty) {
      botoes = <Widget>[
        BotaoDefaultWidget(
          largura: 170,
          onPressed: () {
            Navigator.pop(context);
          },
          textoBotao: mensagemOpcionalBotao,
        ),
      ];
    } else if (botoes.length > 1) {
      posicaoBotao = MainAxisAlignment.end;
    }

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: espacamentoHorizontal!,
        vertical: espacamentoVertical!,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // CABECALHO
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: cabecalho!,
          ),
          // CORPO
          corpo!,

          // BOTOES
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: posicaoBotao,
              children: botoes,
            ),
          ),
        ],
      ),
    );
  }
}
