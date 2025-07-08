import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'dialog_default.widget.dart';

Future<bool?> mostrarDialogSemInternet(BuildContext context) {
  String mensagem = "Sua prova será enviada quando houver conexão com a internet.";
  String icone = AssetsUtil.semConexao;
  String mensagemBotao = "ENTENDI";

  final temaStore = GetIt.I.get<TemaStore>();

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: SvgPicture.asset(icone),
        corpo: Observer(
          builder: (_) {
            return Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TemaUtil.temaTextoMensagemDialog.copyWith(
                fontSize: temaStore.tTexto20,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            );
          },
        ),
        botoes: [
          BotaoDefaultWidget(
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

Future<bool?> mostrarDialogProvaFinalizadaAutomaticamente(BuildContext context) {
  final temaStore = GetIt.I.get<TemaStore>();

  String mensagem =
      "Sua prova foi finalizada, pois o tempo acabou. As questões com resposta foram enviadas com sucesso.";
  String icone = AssetsUtil.check;
  String mensagemBotao = "ENTENDI";

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: SvgPicture.asset(icone),
        corpo: Observer(
          builder: (_) {
            return Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TemaUtil.temaTextoMensagemDialog.copyWith(
                fontSize: temaStore.tTexto20,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            );
          },
        ),
        botoes: [
          BotaoDefaultWidget(
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

Future<bool?> mostrarDialogProvaEnviada(BuildContext context) {
  final temaStore = GetIt.I.get<TemaStore>();

  String mensagem = "Sua prova foi enviada com sucesso!";
  String icone = AssetsUtil.check;
  String mensagemBotao = "OK";

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: SvgPicture.asset(icone),
        corpo: Observer(
          builder: (_) {
            return Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TemaUtil.temaTextoMensagemDialog.copyWith(
                fontSize: temaStore.tTexto20,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            );
          },
        ),
        botoes: [
          BotaoDefaultWidget(
            onPressed: () {
              Navigator.pop(context, true);
              return true;
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

Future<bool?> mostrarDialogProvaJaEnviada(BuildContext context) {
  final temaStore = GetIt.I.get<TemaStore>();

  String mensagem = "Esta prova já foi finalizada";
  String icone = AssetsUtil.erro;
  String mensagemBotao = "OK";

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: SvgPicture.asset(
          icone,
          height: 55,
        ),
        corpo: Observer(
          builder: (_) {
            return Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TemaUtil.temaTextoMensagemDialog.copyWith(
                fontSize: temaStore.tTexto20,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            );
          },
        ),
        botoes: [
          BotaoDefaultWidget(
            onPressed: () {
              Navigator.pop(context, true);
              return true;
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

Future<bool?> mostrarDialogAindaPossuiTempo(BuildContext context, Duration tempo) {
  final temaStore = GetIt.I.get<TemaStore>();

  String mensagemCorpo =
      "Se finalizar a prova agora, não poderá mais fazer alterações mesmo que o tempo não tenha se esgotado";

  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Observer(
            builder: (_) {
              return RichText(
                textAlign: TextAlign.left,
                maxLines: 10,
                text: TextSpan(
                  text: "Você ainda tem ",
                  style: TemaUtil.temaTextoTempoDialog.copyWith(
                    fontSize: temaStore.tTexto16,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                  children: [
                    TextSpan(
                      text: formatDuration(tempo),
                      style: TemaUtil.temaTextoDuracaoDialog.copyWith(
                        fontSize: temaStore.tTexto16,
                        fontFamily: temaStore.fonteDoTexto.nomeFonte,
                      ),
                      children: [
                        TextSpan(
                          text: " para fazer a prova, tem certeza que quer finalizar agora?",
                          style: TextStyle(
                            fontSize: temaStore.tTexto16,
                            fontFamily: temaStore.fonteDoTexto.nomeFonte,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Texto(
            mensagemCorpo,
            textOverflow: TextOverflow.visible,
            textAlign: TextAlign.left,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        botoes: [
          BotaoSecundarioWidget(
            textoBotao: "CANCELAR",
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          BotaoDefaultWidget(
            textoBotao: "FINALIZAR PROVA",
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      );
    },
  );
}

_buildFontButton({
  required String texto,
  required FonteTipoEnum fontFamily,
  double tamanhoFonte = 48,
  required bool ativo,
  required void Function()? onPressed,
}) {
  final temaStore = GetIt.I.get<TemaStore>();

  return Padding(
    padding: const EdgeInsets.only(right: 24),
    child: InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          SizedBox(
            height: 75,
            child: Text(
              "Aa",
              style: TextStyle(
                fontSize: tamanhoFonte,
                color: ativo ? TemaUtil.azulScroll : Colors.black,
                fontFamily: fontFamily.nomeFonte,
              ),
            ),
          ),
          Container(
            height: 4,
            width: 72,
            padding: EdgeInsets.only(top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: ativo ? TemaUtil.azulScroll : Colors.transparent,
            ),
          ),
          SizedBox(
            child: Text(
              texto,
              style: TextStyle(
                fontSize: 14,
                color: ativo ? TemaUtil.azulScroll : Colors.black,
                decoration: TextDecoration.none,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<bool?> mostrarDialogSenhaErrada(BuildContext context) {
  String mensagemCorpo = "O código está incorreto. Solicite o código para o professor.";

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: SvgPicture.asset(
            AssetsUtil.erro,
            height: 55,
          ),
        ),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Texto(
            mensagemCorpo,
            textOverflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        botoes: [
          BotaoDefaultWidget(
            onPressed: () {
              Navigator.pop(context, true);
            },
            textoBotao: "ENTENDI",
          )
        ],
      );
    },
  );
}

mostrarDialogMudancaTema(BuildContext context) {
  final temaStore = GetIt.I.get<TemaStore>();

  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    transitionDuration: Duration(microseconds: 1),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.topRight,
        child: Observer(
          builder: (_) {
            return Container(
              height: temaStore.fonteDoTexto == FonteTipoEnum.OPEN_DYSLEXIC ? 305 : 300,
              width: 360,
              margin: EdgeInsets.only(right: 60),
              padding: EdgeInsets.all(16),
              child: Material(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Tipo de letra",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                          color: Colors.black87,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildFontButton(
                          texto: "Padrão",
                          fontFamily: FonteTipoEnum.POPPINS,
                          ativo: temaStore.fonteDoTexto == FonteTipoEnum.POPPINS,
                          onPressed: () {
                            temaStore.mudarFonte(FonteTipoEnum.POPPINS);
                          },
                        ),
                        _buildFontButton(
                          texto: "Para dislexia",
                          fontFamily: FonteTipoEnum.OPEN_DYSLEXIC,
                          tamanhoFonte: 44,
                          ativo: temaStore.fonteDoTexto == FonteTipoEnum.OPEN_DYSLEXIC,
                          onPressed: () {
                            temaStore.mudarFonte(FonteTipoEnum.OPEN_DYSLEXIC);
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Divider(
                        color: Colors.black87,
                        height: 16,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Tamanho da letra",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "A",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: temaStore.fonteDoTexto.nomeFonte,
                            ),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 8,
                              ),
                              child: Slider(
                                value: temaStore.incrementador,
                                min: 10,
                                max: 24,
                                divisions: 7,
                                label: temaStore.incrementador.round().toString(),
                                activeColor: TemaUtil.azulScroll,
                                inactiveColor: Colors.grey[350],
                                onChangeEnd: (_) {
                                  temaStore.enviarPreferencias();
                                },
                                onChanged: (double valor) {
                                  var min = kIsTablet ? 16 : 14;

                                  if (valor >= min && valor <= 24) {
                                    temaStore.fachadaAlterarTamanhoDoTexto(valor, update: false);
                                  }
                                },
                              ),
                            ),
                          ),
                          Text(
                            "A",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontFamily: temaStore.fonteDoTexto.nomeFonte,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 0), end: Offset(0, 0.078)).animate(anim),
        child: child,
      );
    },
  );
}

Future<bool?> mostrarDialogVoltarProva(BuildContext context) {
  String mensagemCorpo =
      "Você deseja voltar para a tela inicial? Caso a prova possua tempo de execução, o mesmo não será pausado.";

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: SvgPicture.asset(
            AssetsUtil.erro,
            height: 55,
          ),
        ),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Texto(
            mensagemCorpo,
            textOverflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        botoes: [
          BotaoSecundarioWidget(
            textoBotao: "CANCELAR",
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          BotaoDefaultWidget(
            textoBotao: "VOLTAR",
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      );
    },
  );
}

Future<bool?> mostrarDialogSairSistema(BuildContext context) {
  String mensagemCorpo = "Deseja realmente sair?";

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: SvgPicture.asset(
            AssetsUtil.erro,
            height: 55,
          ),
        ),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Texto(
            mensagemCorpo,
            textOverflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        botoes: [
          BotaoSecundarioWidget(
            textoBotao: "CANCELAR",
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          BotaoDefaultWidget(
            textoBotao: "SAIR",
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      );
    },
  );
}

Future<bool?> mostrarDialogNaoPossuiTempoTotalDisponivel(BuildContext context, Duration tempoDisponivel) {
  final temaStore = GetIt.I.get<TemaStore>();

  String tempoRestante = formatDuration(tempoDisponivel);

  String mensagemCorpo1 = "Se você iniciar a prova agora terá apenas ";
  String mensagemCorpo2 = " para respondê-la. Deseja continuar?";

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: SvgPicture.asset(
            AssetsUtil.erro,
            height: 55,
          ),
        ),
        corpo: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: mensagemCorpo1,
                ),
                TextSpan(
                  text: tempoRestante,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: mensagemCorpo2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: temaStore.fonteDoTexto.nomeFonte,
            ),
          ),
        ),
        botoes: [
          BotaoSecundarioWidget(
            textoBotao: "CANCELAR",
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          BotaoDefaultWidget(
            textoBotao: "CONTINUAR",
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      );
    },
  );
}

horaDispositivoIncorreta(BuildContext context, DateTime dataHoraServidor) {
  final temaStore = GetIt.I.get<TemaStore>();

  String dataHora = DateFormat("dd/MM/yyyy - H:mm'h'").format(dataHoraServidor);

  String mensagem1 = "O seu dispositivo está com data/hora diferente do servidor que é $dataHora.";
  String mensagem2 = "Sugerimos que você ajuste a data/hora antes de iniciar a prova.";
  String mensagemBotao = "ENTENDI";

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: Container(),
        corpo: Observer(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  mensagem1,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
                Text(
                  mensagem2,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
              ],
            );
          },
        ),
        botoes: [
          BotaoDefaultWidget(
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}

Future<bool?> mostrarDialogErroIrProximaQuestaoTai(BuildContext context) {
  final temaStore = GetIt.I.get<TemaStore>();

  String mensagem = "Erro ao obter a próxima questão. Esta prova precisa ser reiniciada.";
  String icone = AssetsUtil.erro;
  String mensagemBotao = "OK";

  return showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      return DialogDefaultWidget(
        cabecalho: SvgPicture.asset(
          icone,
          height: 55,
        ),
        corpo: Observer(
          builder: (_) {
            return Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TemaUtil.temaTextoMensagemDialog.copyWith(
                fontSize: temaStore.tTexto20,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            );
          },
        ),
        botoes: [
          BotaoDefaultWidget(
            onPressed: () {
              Navigator.pop(context, true);
              return true;
            },
            textoBotao: mensagemBotao,
          )
        ],
      );
    },
  );
}
