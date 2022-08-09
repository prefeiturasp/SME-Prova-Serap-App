import 'dart:convert';
import 'dart:typed_data';

import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tipo_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/models/resposta_prova.model.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/views/prova/prova.view.util.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:photo_view/photo_view.dart';

class QuestaoAlunoWidget extends StatelessWidget with Loggable, ProvaViewUtil {
  final TemaStore temaStore = ServiceLocator.get<TemaStore>();
  final controller = HtmlEditorController();

  final ProvaStore provaStore;
  final Questao questao;
  final List<Arquivo> imagens;
  final List<Alternativa> alternativas;

  QuestaoAlunoWidget({
    Key? key,
    required this.provaStore,
    required this.questao,
    required this.imagens,
    required this.alternativas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTratamentoImagem(provaStore, imagens, questao, alternativas),
        Observer(builder: (_) {
          return Html(
            data: tratarArquivos(questao.titulo, imagens, EnumTipoImagem.QUESTAO, provaStore.tratamentoImagem),
            style: {
              '*': Style.fromTextStyle(
                TemaUtil.temaTextoHtmlPadrao.copyWith(
                  fontSize: temaStore.tTexto16,
                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                ),
              ),
              'span': Style.fromTextStyle(
                TextStyle(
                    fontSize: temaStore.tTexto16,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                    color: TemaUtil.pretoSemFoco3),
              ),
            },
            onImageTap: (url, _, attributes, element) async {
              late Uint8List imagem;

              if (url!.startsWith('http')) {
                imagem = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
              } else {
                imagem = base64.decode(url.split(',').last);
              }

              _exibirImagem(context, imagem);
            },
          );
        }),
        SizedBox(height: 8),
        Observer(builder: (_) {
          return Html(
            data: tratarArquivos(questao.descricao, imagens, EnumTipoImagem.QUESTAO, provaStore.tratamentoImagem),
            style: {
              '*': Style.fromTextStyle(
                TemaUtil.temaTextoHtmlPadrao.copyWith(
                  fontSize: temaStore.tTexto16,
                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                ),
              ),
              'span': Style.fromTextStyle(
                TextStyle(
                  fontSize: temaStore.tTexto16,
                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  color: TemaUtil.pretoSemFoco3,
                ),
              ),
            },
            onImageTap: (url, _, attributes, element) async {
              late Uint8List imagem;

              if (url!.startsWith('http')) {
                imagem = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
              } else {
                imagem = base64.decode(url.split(',').last);
              }

              _exibirImagem(context, imagem);
            },
          );
        }),
        SizedBox(height: 16),
        Observer(builder: (_) {
          return _buildResposta(questao);
        }),
      ],
    );
  }

  Future<T?> _exibirImagem<T>(BuildContext context, Uint8List image) async {
    return await showDialog<T>(
      context: context,
      builder: (_) {
        var background = Colors.transparent;

        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black.withOpacity(0.5),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: PhotoView(
                      backgroundDecoration: BoxDecoration(color: background),
                      imageProvider: MemoryImage(image),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.close, color: TemaUtil.laranja02),
                        SizedBox(
                          width: 8,
                        ),
                        Observer(
                          builder: (_) {
                            return Text(
                              'Fechar',
                              style: TemaUtil.temaTextoFecharImagem.copyWith(
                                fontSize: temaStore.tTexto18,
                                fontFamily: temaStore.fonteDoTexto.nomeFonte,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResposta(Questao questao) {
    switch (questao.tipo) {
      case EnumTipoQuestao.MULTIPLA_ESCOLHA:
        return _buildAlternativas(questao);
      case EnumTipoQuestao.RESPOSTA_CONTRUIDA:
        return _buildRespostaConstruida(questao);

      default:
        return SizedBox.shrink();
    }
  }

  _buildRespostaConstruida(Questao questao) {
    RespostaProva? provaResposta = provaStore.respostas.obterResposta(questao.id);

    return Column(
      children: [
        //
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Observer(builder: (_) {
              return HtmlEditor(
                controller: controller,
                callbacks: Callbacks(
                  onInit: () {
                    controller.execCommand('fontName', argument: temaStore.fonteDoTexto.nomeFonte);
                    controller.setText(provaResposta?.resposta ?? "");
                  },
                  onChangeContent: (String? textoDigitado) {
                    provaStore.respostas.definirResposta(questao.id, textoResposta: textoDigitado);
                  },
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  toolbarPosition: ToolbarPosition.belowEditor,
                  defaultToolbarButtons: [
                    FontButtons(
                      subscript: false,
                      superscript: false,
                      strikethrough: false,
                    ),
                    ParagraphButtons(
                      lineHeight: false,
                      caseConverter: false,
                      decreaseIndent: true,
                      increaseIndent: true,
                      textDirection: false,
                      alignRight: false,
                    ),
                    ListButtons(
                      listStyles: false,
                    ),
                  ],
                ),
                htmlEditorOptions: HtmlEditorOptions(
                  autoAdjustHeight: false,
                  hint: "Digite sua resposta aqui...",
                ),
                otherOptions: OtherOptions(
                  height: 400,
                ),
              );
            }),
          ),
        ),
        //
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          width: double.infinity,
          child: Texto(
            'Caracteres digitados: ${provaResposta?.resposta?.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ').length}',
            textAlign: TextAlign.end,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  _buildAlternativas(Questao questao) {
    alternativas.sort((a, b) => a.ordem.compareTo(b.ordem));
    return ListTileTheme.merge(
      horizontalTitleGap: 0,
      child: Column(
        children: alternativas
            .map((e) => _buildAlternativa(
                  e.id,
                  e.numeracao,
                  questao,
                  e.descricao,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildAlternativa(int idAlternativa, String numeracao, Questao questao, String descricao) {
    RespostaProva? resposta = provaStore.respostas.obterResposta(questao.id);

    return Observer(
      builder: (_) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black.withOpacity(0.34),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: RadioListTile<int>(
            contentPadding: EdgeInsets.all(0),
            toggleable: true,
            dense: true,
            value: idAlternativa,
            groupValue: resposta?.alternativaId,
            onChanged: (value) async {
              await provaStore.respostas.definirResposta(
                questao.id,
                alternativaId: value,
                tempoQuestao: provaStore.segundos,
              );
            },
            title: Row(
              children: [
                Text(
                  "$numeracao ",
                  style: TemaUtil.temaTextoNumeracao.copyWith(
                    fontSize: temaStore.tTexto16,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
                Expanded(
                  child: Observer(builder: (_) {
                    return Html(
                      data: tratarArquivos(descricao, imagens, EnumTipoImagem.ALTERNATIVA, provaStore.tratamentoImagem),
                      style: {
                        '*': Style.fromTextStyle(
                          TemaUtil.temaTextoPadrao.copyWith(
                            fontSize: temaStore.tTexto16,
                            fontFamily: temaStore.fonteDoTexto.nomeFonte,
                          ),
                        )
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
