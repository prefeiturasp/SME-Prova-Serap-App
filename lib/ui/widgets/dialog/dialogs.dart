import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dialog_default.widget.dart';

Future<bool>? mostrarDialogSemInternet() {
  String mensagem = "Sua prova será enviada quando houver conexão com a internet.";
  String icone = AssetsUtil.semConexao;
  String mensagemBotao = "ENTENDI";

  asuka.showDialog(
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: SvgPicture.asset(icone),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 70,
          ),
          child: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        botoes: [
          BotaoDefaultWidget(
            largura: 170,
            onPressed: () async {
              Navigator.of(context).pop();
              return true;
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

mostrarDialogProvaEnviada() {
  String mensagem = "Sua prova foi enviada com sucesso!";
  String icone = AssetsUtil.check;
  String mensagemBotao = "OK";

  asuka.showDialog(
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        espacamentoVertical: .32,
        cabecalho: SvgPicture.asset(icone),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 70,
          ),
          child: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        botoes: [
          BotaoDefaultWidget(
            largura: 170,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => HomeView()),
                  (Route<dynamic> route) => false);
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

mostrarDialogProvaJaEnviada() {
  String mensagem = "Esta prova já foi finalizada";
  String icone = AssetsUtil.erro;
  String mensagemBotao = "OK";

  asuka.showDialog(
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        espacamentoVertical: .35,
        cabecalho: SvgPicture.asset(icone),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 70,
          ),
          child: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        botoes: [
          BotaoDefaultWidget(
            largura: 170,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => HomeView()),
                  (Route<dynamic> route) => false);
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

mostrarDialogAindaPossuiTempo(String tempo) {
  String mensagemCorpo =
      "Se finalizar a prova agora, não poderá mais fazer alterações mesmo que o tempo não tenha se esgotado";

  asuka.showDialog(
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        espacamentoVertical: .35,
        espacamentoHorizontal: .1,
        dialogLargo: true,
        cabecalho: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: "Você ainda tem ",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
              children: [
                TextSpan(
                  text: tempo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                      text: " para fazer a prova, tem certeza que quer finalizar agora?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Text(
            mensagemCorpo,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.7)),
          ),
        ),
        botoes: [
          BotaoSecundarioWidget(
            textoBotao: "CAMCELAR",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BotaoDefaultWidget(
            onPressed: () {},
            textoBotao: "FINALIZAR PROVA",
          )
        ],
      );
    },
  );
}
