import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dialog_default.widget.dart';

mostrarDialogSemInternet() {
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

mostrarDialogProvaEnviada() {
  String mensagem = "Sua prova foi enviada com sucesso!";
  String icone = AssetsUtil.check;
  String mensagemBotao = "OK";

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
