import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:photo_view/photo_view.dart';

import 'resumo_respostas.view.dart';

class ProvaView extends BaseStatefulWidget {
  const ProvaView({required this.provaStore}) : super(title: "Prova");
  final ProvaStore provaStore;

  @override
  _ProvaViewState createState() => _ProvaViewState();
}

class _ProvaViewState extends BaseStateWidget<ProvaView, ProvaViewStore> with Loggable {
  final PageController listaQuestoesController = PageController(initialPage: 0);

  HtmlEditorController controller = HtmlEditorController();

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  void initState() {
    store.questoes = widget.provaStore.prova.questoes;
    store.setup();
    super.initState();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      subtitulo: widget.provaStore.prova.descricao,
    );
  }

  @override
  Widget builder(BuildContext context) {
    var questoes = widget.provaStore.prova.questoes;

    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      controller: listaQuestoesController,
      onPageChanged: (value) {
        store.questaoAtual = value + 1;
      },
      itemCount: questoes.length,
      itemBuilder: (context, index) {
        return _buildQuestoes(questoes[index], index);
      },
    );
  }

  Widget _botoesProva(Questao questao) {
    if (store.revisandoProva) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Observer(
              builder: (context) {
                if (store.questaoAtual < widget.provaStore.prova.questoes.length) {
                  return BotaoDefaultWidget(
                    textoBotao: 'Proximo item da revisão',
                    onPressed: () async {
                      //! IMPLEMENTAR
                      if (store.respostas[questao.id] != null) {
                        await store.sincronizarResposta();
                        await store.obterRespostasServidor();
                      }

                      listaQuestoesController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                      store.questaoAtual++;
                    },
                  );
                }
                return Container();
              },
            ),
            Observer(
              builder: (context) {
                return BotaoDefaultWidget(
                  textoBotao: 'Confirmar e voltar para o resumo',
                  onPressed: () async {
                    try {
                      await store.sincronizarResposta();
                      await store.obterRespostasServidor();
                      String posicaoDaQuestao = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResumoRespostasView(
                            provaStore: widget.provaStore,
                          ),
                        ),
                      );

                      if (!int.parse(posicaoDaQuestao).isNaN) {
                        store.revisandoProva = true;
                        store.questaoAtual = int.parse(posicaoDaQuestao);
                        listaQuestoesController.jumpToPage(
                          int.parse(posicaoDaQuestao),
                        );
                      }
                    } catch (e) {
                      fine(e);
                    }
                  },
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Observer(
            builder: (context) {
              if (store.questaoAtual == 1) {
                return SizedBox.shrink();
              }

              return BotaoSecundarioWidget(
                textoBotao: 'Questão anterior',
                onPressed: () {
                  listaQuestoesController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              );
            },
          ),
          Observer(
            builder: (context) {
              if (store.questaoAtual < widget.provaStore.prova.questoes.length) {
                return BotaoDefaultWidget(
                  textoBotao: 'Proxima questão',
                  onPressed: () async {
                    if (questao.tipo == EnumTipoQuestao.RESPOSTA_CONTRUIDA) {
                      await store.definirResposta(questao.id, await controller.getText());
                    }

                    if (store.respostas[questao.id] != null) {
                      await store.sincronizarResposta();
                    }

                    listaQuestoesController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                    store.questaoAtual++;
                  },
                );
              }

              return BotaoDefaultWidget(
                textoBotao: 'Finalizar prova',
                onPressed: () async {
                  await store.sincronizarResposta();
                  try {
                    int posicaoDaQuestao = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResumoRespostasView(
                          provaStore: widget.provaStore,
                        ),
                      ),
                    );

                    if (!posicaoDaQuestao.isNaN) {
                      store.revisandoProva = true;
                      store.questaoAtual = posicaoDaQuestao;
                      listaQuestoesController.jumpToPage(posicaoDaQuestao);
                    }
                  } catch (e) {
                    fine(e);
                  }
                },
              );
            },
          ),
        ],
      );
    }
  }

  Widget _buildQuestoes(Questao questao, int index) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Questão ${index + 1} ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'de ${widget.provaStore.prova.questoes.length}',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Html(
                  data: tratarArquivos(questao.titulo, questao.arquivos),
                  style: {
                    '*': Style.fromTextStyle(GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                  },
                  onImageTap: (url, _, attributes, element) {
                    Uint8List imagem = base64.decode(url!.split(',').last);

                    _exibirImagem(context, imagem);
                  },
                ),
                SizedBox(height: 8),
                Html(
                  data: tratarArquivos(questao.descricao, questao.arquivos),
                  style: {
                    '*': Style.fromTextStyle(GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                  },
                  onImageTap: (url, _, attributes, element) {
                    Uint8List imagem = base64.decode(url!.split(',').last);

                    _exibirImagem(context, imagem);
                  },
                ),
                SizedBox(height: 16),
                Observer(builder: (_) {
                  return _buildResposta(questao);
                }),
              ],
            ),
          ),
          Observer(builder: (context) {
            return _botoesProva(questao);
          }),
        ],
      ),
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
                        Text(
                          'Fechar',
                          style: TextStyle(
                            fontSize: 18,
                            color: TemaUtil.laranja02,
                            fontWeight: FontWeight.bold,
                          ),
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
    ProvaResposta? provaResposta = store.obterResposta(questao.id);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: HtmlEditor(
          controller: controller,
          callbacks: Callbacks(onInit: () {
            controller.execCommand('fontName', argument: "Poppins");
            controller.setText(provaResposta?.resposta ?? "");
          }),
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
            hint: "Digite sua resposta aqui...",
          ),
          otherOptions: OtherOptions(
            height: 328,
          ),
        ),
      ),
    );
  }

  _buildAlternativas(Questao questao) {
    List<Alternativa> alternativasQuestoes = questao.alternativas;

    alternativasQuestoes.sort((a, b) => a.ordem.compareTo(b.ordem));
    return Column(
      children: alternativasQuestoes.map((e) => _buildAlternativa(e.id, e.numeracao, questao.id, e.descricao)).toList(),
    );
  }

  Widget _buildAlternativa(int idAlternativa, String numeracao, int questaoId, String descricao) {
    ProvaResposta? resposta = store.obterResposta(questaoId);

    return Container(
      padding: EdgeInsets.all(8),
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
        value: idAlternativa,
        groupValue: resposta?.alternativaId,
        onChanged: (value) {
          store.definirAlternativa(questaoId, value);
        },
        toggleable: true,
        title: Row(children: [
          Text(
            "$numeracao ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Html(
              data: descricao,
              style: {
                '*': Style.fromTextStyle(
                  GoogleFonts.poppins(fontSize: 16),
                )
              },
            ),
          ),
        ]),
      ),
    );
  }

  String tratarArquivos(String texto, List<Arquivo> arquivos) {
    texto = texto.replaceAllMapped(RegExp(r'(<img[^>]*>)'), (match) {
      return '<div style="text-align: center">${match.group(0)}</div>';
    });

    RegExp exp = RegExp(r"#(\d+)#", multiLine: true, caseSensitive: true);
    var matches = exp.allMatches(texto).toList();

    for (var i = 0; i < matches.length; i++) {
      var arquivoId = texto.substring(matches[i].start, matches[i].end);
      var arquivo = arquivos.where((arq) => arq.id == int.parse(arquivoId.split("#")[1])).first;
      var obterTipo = arquivo.caminho.split(".");

      texto = texto.replaceAll(arquivoId, "data:image/${obterTipo[obterTipo.length - 1]};base64,${arquivo.base64}");
    }
    return texto;
    // #123456#
  }
}
