import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DialogDefaultWidget extends StatelessWidget {
  Widget? cabecalho;
  Widget corpo;
  List<Widget> botoes = <Widget>[];
  String? mensagemOpcionalBotao;
  double? maxWidth;

  DialogDefaultWidget({
    this.cabecalho,
    required this.corpo,
    this.botoes = const [],
    this.mensagemOpcionalBotao = "",
    this.maxWidth = 600.0,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth!),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: cabecalho!,
            ),

            // CORPO
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: corpo,
            ),

            // BOTOES
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildButtons(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildButtons(context) {
    if (botoes.isEmpty) {
      return [
        BotaoDefaultWidget(
          largura: 170,
          onPressed: () {
            Navigator.pop(context);
          },
          textoBotao: mensagemOpcionalBotao,
        )
      ];
    }

    return botoes;
  }
}
