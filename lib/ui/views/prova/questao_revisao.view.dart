import 'dart:convert';
import 'dart:typed_data';

import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tempo_status.enum.dart';
import 'package:appserap/enums/tipo_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/questao_revisao.store.dart';
import 'package:appserap/ui/views/prova/widgets/tempo_execucao.widget.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/workers/sincronizar_resposta.worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:photo_view/photo_view.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class QuestaoRevisaoView extends BaseStatefulWidget {
  final int idProva;
  final int ordem;

  QuestaoRevisaoView({Key? key, required this.idProva, required this.ordem}) : super(key: key);

  @override
  _QuestaoRevisaoViewState createState() => _QuestaoRevisaoViewState();
}

class _QuestaoRevisaoViewState extends BaseStateWidget<QuestaoRevisaoView, QuestaoRevisaoStore> with Loggable {
  late ProvaStore provaStore;
  late Questao questao;

  final controller = HtmlEditorController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    provaStore = ServiceLocator.get<HomeStore>().provas.filter((prova) => prova.key == widget.idProva).first.value;
    questao = provaStore.prova.questoes.where((element) => element.ordem == widget.ordem).first;
  }

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  double get defaultPadding => 0;

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      subtitulo: provaStore.prova.descricao,
    );
  }

  @override
  Widget builder(BuildContext context) {
    var questoes = store.questoesParaRevisar.toList();
    store.totalDeQuestoesParaRevisar = questoes.length - 1;

    return Column(
      children: [
        TempoExecucaoWidget(provaStore: provaStore),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: getPadding(),
              child: Column(
                children: [
                  Observer(builder: (_) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Questão ${questao.ordem + 1} ',
                                style: TemaUtil.temaTextoNumeroQuestoes.copyWith(
                                  fontSize: temaStore.tTexto20,
                                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                                ),
                              ),
                              Text(
                                'de ${provaStore.prova.questoes.length}',
                                style: TemaUtil.temaTextoNumeroQuestoesTotal.copyWith(
                                  fontSize: temaStore.tTexto20,
                                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Html(
                            data: tratarArquivos(questao.titulo, questao.arquivos, EnumTipoImagem.QUESTAO),
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
                            onImageTap: (url, _, attributes, element) {
                              Uint8List imagem = base64.decode(url!.split(',').last);

                              _exibirImagem(context, imagem);
                            },
                          ),
                          SizedBox(height: 8),
                          Html(
                            data: tratarArquivos(questao.descricao, questao.arquivos, EnumTipoImagem.QUESTAO),
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
                    );
                  }),
                  Observer(builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 20,
                      ),
                      child: _buildBotoes(questao),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
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
    ProvaResposta? provaResposta = provaStore.respostas.obterResposta(questao.id);

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
          width: MediaQuery.of(context).size.width,
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
    List<Alternativa> alternativasQuestoes = questao.alternativas;

    alternativasQuestoes.sort((a, b) => a.ordem.compareTo(b.ordem));
    return ListTileTheme.merge(
      horizontalTitleGap: 0,
      child: Column(
        children: alternativasQuestoes
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
    ProvaResposta? resposta = provaStore.respostas.obterResposta(questao.id);

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
                tempoQuestao: null,
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
                  child: Html(
                    data: tratarArquivos(descricao, questao.arquivos, EnumTipoImagem.ALTERNATIVA),
                    style: {
                      '*': Style.fromTextStyle(
                        TemaUtil.temaTextoPadrao.copyWith(
                          fontSize: temaStore.tTexto16,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      )
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String tratarArquivos(String texto, List<Arquivo> arquivos, EnumTipoImagem tipoImagem) {
    if (tipoImagem == EnumTipoImagem.QUESTAO) {
      texto = texto.replaceAllMapped(RegExp(r'(<img[^>]*>)'), (match) {
        return '<div style="text-align: center; position:relative">${match.group(0)}<p><span>Toque na imagem para ampliar</span></p></div>';
      });
    }

    for (var arquivo in arquivos) {
      var obterTipo = arquivo.caminho.split(".");
      texto =
          texto.replaceAll("#${arquivo.id}#", "data:image/${obterTipo[obterTipo.length - 1]};base64,${arquivo.base64}");
    }

    texto = texto.replaceAll("#0#", AssetsUtil.notfound);

    return texto;
  }

  Widget _buildBotoes(Questao questao) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Observer(
          builder: (context) {
            if (store.posicaoQuestaoSendoRevisada != store.totalDeQuestoesParaRevisar) {
              return BotaoDefaultWidget(
                textoBotao: 'Proximo item da revisão',
                onPressed: () async {
                  store.posicaoQuestaoSendoRevisada++;
                  context.go("/prova/${widget.idProva}/revisao/${store.posicaoQuestaoSendoRevisada}");
                },
              );
            }
            return Container();
          },
        ),
        SizedBox(
          height: 8,
        ),
        BotaoDefaultWidget(
          textoBotao: 'Voltar para o resumo',
          onPressed: () async {
            try {
              if (store.botaoOcupado) return;

              store.botaoOcupado = true;
              provaStore.tempoCorrendo = EnumTempoStatus.PARADO;
              await provaStore.respostas.definirTempoResposta(
                questao.id,
                tempoQuestao: provaStore.segundos,
              );
              await SincronizarRespostasWorker().sincronizar();
              context.go("/prova/${provaStore.id}/resumo");
            } catch (e) {
              fine(e);
            } finally {
              store.botaoOcupado = false;
            }
          },
        ),
      ],
    );
  }
}
