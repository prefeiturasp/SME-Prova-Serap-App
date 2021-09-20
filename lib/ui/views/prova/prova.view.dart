import 'dart:convert';
import 'dart:typed_data';

import 'package:appserap/dtos/prova_alternativa.dto.dart';
import 'package:appserap/dtos/prova_questao.dto.dart';
import 'package:appserap/stores/prova_atual.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:photo_view/photo_view.dart';

class ProvaView extends BaseStatefulWidget {
  const ProvaView({required this.provaId}) : super(title: "Prova");
  final int provaId;

  @override
  _ProvaViewState createState() => _ProvaViewState();
}

class _ProvaViewState extends BaseStateWidget<ProvaView, ProvaAtualStore> {
  final PageController listaQuestoesController = PageController(initialPage: 0);

  HtmlEditorController controller = HtmlEditorController();

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  void initState() {
    super.initState();
    store.carregarProva(this.widget.provaId);
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBarWidget();
  }

  @override
  Widget builder(BuildContext context) {
    var questoes = store.questoes;

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

  Widget _buildQuestoes(ProvaQuestaoDTO questao, int index) {
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
                      'de ${store.questoes.length}',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    )
                  ],
                ),
                SizedBox(height: 8),
                HtmlWidget(
                  tratarArquivos(questao.titulo ?? ''),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  onTapImage: (ImageMetadata imageMetadata) {
                    Uint8List image = base64.decode(imageMetadata.sources.first.url.split(',').last);

                    _showImage(context, image);
                  },
                ),
                SizedBox(height: 8),
                HtmlWidget(
                  tratarArquivos(questao.descricao ?? ''),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  onTapImage: (ImageMetadata imageMetadata) {
                    print(imageMetadata.sources.first.url);
                  },
                ),
                SizedBox(height: 16),
                _buildResposta(questao),
              ],
            ),
          ),
          Row(
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
                  if (store.questaoAtual < store.questoes.length) {
                    return BotaoDefaultWidget(
                      textoBotao: 'Proxima questão',
                      onPressed: () async {
                        await store.adicionarResposta(questao.id!, store.resposta!);
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
                    onPressed: () {
                      store.questaoAtual = 0;
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<T?> _showImage<T>(BuildContext context, Uint8List image) async {
    return await showDialog<T>(
      context: context,
      builder: (_) {
        var background = Colors.transparent;

        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black.withOpacity(0.5),
          content: Container(
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
                      Navigator.pop(context);
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
                          style: TextStyle(fontSize: 18, color: TemaUtil.laranja02, fontWeight: FontWeight.bold),
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

  Widget _buildResposta(ProvaQuestaoDTO questao) {
    switch (questao.tipo) {
      case EnumTipoQuestao.multiplaEscolha:
        return _buildAlternativas(questao);
      case EnumTipoQuestao.descritiva:
        return _buildDescritiva(questao);

      default:
        return SizedBox.shrink();
    }
  }

  _buildDescritiva(ProvaQuestaoDTO questao) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: HtmlEditor(
          controller: controller,
          htmlToolbarOptions: HtmlToolbarOptions(
            toolbarPosition: ToolbarPosition.belowEditor,
            defaultToolbarButtons: [
              // FontSettingButtons(
              //   fontName: false,
              //   fontSizeUnit: false,
              // ),
              FontButtons(
                subscript: false,
                superscript: false,
                strikethrough: false,
              ),
              ParagraphButtons(
                lineHeight: false,
                caseConverter: false,
                decreaseIndent: false,
                increaseIndent: false,
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

  _buildAlternativas(ProvaQuestaoDTO questao) {
    List<ProvaAlternativaDTO> alternativasQuestoes =
        store.alternativas.where((element) => element.questaoId == questao.id).toList();

    alternativasQuestoes.sort((a, b) => a.ordem!.compareTo(b.ordem!));

    return Column(
      children: alternativasQuestoes.map((e) => _buildAlternativa(e.id, e.numeracao, e.descricao)).toList(),
    );
  }

  Widget _buildAlternativa(int? id, String? numeracao, String? descricao) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Row(
        children: [
          Observer(builder: (_) {
            return Radio<int?>(
              value: id,
              groupValue: store.resposta,
              onChanged: (value) => store.resposta = value,
            );
          }),
          Expanded(
            child: Row(
              children: [
                Text(
                  "$numeracao ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                HtmlWidget(
                  descricao!,
                  textStyle: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String tratarArquivos(String texto) {
    texto = texto.replaceAllMapped(RegExp(r'(<img[^>]*>)'), (match) {
      return '<center>${match.group(0)}</center>';
    });

    RegExp exp = RegExp(r"#(\d+)#", multiLine: true, caseSensitive: true);
    var matches = exp.allMatches(texto).toList();

    for (var i = 0; i < matches.length; i++) {
      var arquivoId = texto.substring(matches[i].start, matches[i].end);
      var arquivo = store.arquivos!.where((arq) => arq.id == int.parse(arquivoId.split("#")[1])).first;
      var obterTipo = arquivo.caminho!.split(".");

      texto = texto.replaceAll(arquivoId, "data:image/${obterTipo[obterTipo.length - 1]};base64,${arquivo.base64}");
    }
    return texto;
    // #123456#
  }
}