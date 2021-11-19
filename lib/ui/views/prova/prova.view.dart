import 'dart:convert';
import 'dart:typed_data';

import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:photo_view/photo_view.dart';

import 'package:appserap/enums/tempo_status.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/managers/tempo.manager.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/barras/barra_progresso.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/workers/sincronizar_resposta.worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  final listaQuestoesController = PageController(initialPage: 0);
  final controller = HtmlEditorController();

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  double get defaultPadding => 0;

  @override
  bool get willPop => false;

  @override
  void initState() {
    store.isLoading = true;

    configure().then((_) async {
      store.isLoading = false;
    });

    widget.provaStore.foraDaPaginaDeRevisao = true;

    super.initState();
  }

  configure() async {
    info("[Prova ${widget.provaStore.id}] - Configurando prova");
    await widget.provaStore.respostas.carregarRespostasServidor(widget.provaStore.prova);
    await _configureControlesTempoProva();
    await store.setup(widget.provaStore);
    info("[Prova ${widget.provaStore.id}] - Configuração concluida");
  }

  _configureControlesTempoProva() async {
    _finalizarProva() async {
      var confirm = await widget.provaStore.finalizarProva(context, true);
      if (confirm) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeView()),
          (_) => false,
        );
      }
    }

    if (widget.provaStore.tempoExecucaoStore != null) {
      switch (widget.provaStore.tempoExecucaoStore!.status) {
        case EnumProvaTempoEventType.EXTENDIDO:
          await _iniciarRevisaoProva();
          break;
        case EnumProvaTempoEventType.FINALIZADO:
          await _finalizarProva();
          break;

        default:
          break;
      }
    }

    if (widget.provaStore.tempoExecucaoStore != null) {
      widget.provaStore.tempoExecucaoStore!.onFinalizandoProva(() {
        fine('Prova quase acabando');
        store.mostrarAlertaDeTempoAcabando = true;
      });

      widget.provaStore.tempoExecucaoStore!.onExtenderProva(() async {
        fine('Prova extendida');
        store.mostrarAlertaDeTempoAcabando = false;
        await _iniciarRevisaoProva();
      });

      widget.provaStore.tempoExecucaoStore!.onFinalizarlProva(() async {
        fine('Prova finalizada');
        await _finalizarProva();
      });
    }
  }

  @override
  void dispose() {
    widget.provaStore.onDispose();
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
    return Observer(builder: (context) {
      if (store.isLoading) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Carregando..."),
          ],
        );
      }

      return WillPopScope(
        onWillPop: () async {
          if (store.revisandoProva) {
            return false;
          }
          return true;
        },
        child: _buildProva(),
      );
    });
  }

  Widget _buildProva() {
    if (store.revisandoProva) {
      var questoes = store.questoesParaRevisar.toList();
      store.totalDeQuestoesParaRevisar = questoes.length - 1;
      return Column(
        children: [
          ..._buildTempoProva(),
          Expanded(
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: listaQuestoesController,
              itemCount: questoes.length,
              itemBuilder: (context, index) {
                store.posicaoQuestaoSendoRevisada = index;
                return _buildQuestoes(questoes[index], index);
              },
            ),
          ),
        ],
      );
    }

    var questoes = widget.provaStore.prova.questoes;

    return Column(
      children: [
        ..._buildTempoProva(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: listaQuestoesController,
              onPageChanged: (value) {
                store.questaoAtual = value + 1;
              },
              itemCount: questoes.length,
              itemBuilder: (context, index) {
                return _buildQuestoes(questoes[index], index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestoes(Questao questao, int index) {
    widget.provaStore.tempoCorrendo = EnumTempoStatus.CORRENDO;
    store.botaoOcupado = false;
    return SingleChildScrollView(
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
                        'de ${widget.provaStore.prova.questoes.length}',
                        style: TemaUtil.temaTextoNumeroQuestoesTotal.copyWith(
                          fontSize: temaStore.tTexto20,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Html(
                    data: tratarArquivos(questao.titulo, questao.arquivos),
                    style: {
                      '*': Style.fromTextStyle(
                        TemaUtil.temaTextoHtmlPadrao.copyWith(
                          fontSize: temaStore.tTexto16,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                      'span': Style.fromTextStyle(
                        TextStyle(color: TemaUtil.pretoSemFoco3),
                      ),
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
                      '*': Style.fromTextStyle(
                        TemaUtil.temaTextoHtmlPadrao.copyWith(
                          fontSize: temaStore.tTexto16,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      ),
                      'span': Style.fromTextStyle(
                        TextStyle(
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
            return _buildBotoes(questao);
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
    ProvaResposta? provaResposta = widget.provaStore.respostas.obterResposta(questao.id);

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
                    widget.provaStore.respostas.definirResposta(questao.id, textoResposta: textoDigitado);
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
                  questao.id,
                  e.descricao,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildAlternativa(int idAlternativa, String numeracao, int questaoId, String descricao) {
    ProvaResposta? resposta = widget.provaStore.respostas.obterResposta(questaoId);

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
            onChanged: (value) {
              widget.provaStore.respostas.definirResposta(
                questaoId,
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
                    data: descricao,
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

  Widget _buildBotaoVoltar(Questao questao) {
    if (store.questaoAtual == 1) {
      return SizedBox.shrink();
    }

    return BotaoSecundarioWidget(
      textoBotao: 'Questão anterior',
      onPressed: () async {
        widget.provaStore.tempoCorrendo = EnumTempoStatus.PARADO;
        await widget.provaStore.respostas.definirTempoResposta(
          questao.id,
          tempoQuestao: widget.provaStore.segundos,
        );
        await SincronizarRespostasWorker().sincronizar();
        listaQuestoesController.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      },
    );
  }

  Widget _buildBotaoProximo(Questao questao) {
    if (store.questaoAtual < widget.provaStore.prova.questoes.length) {
      return BotaoDefaultWidget(
        textoBotao: 'Próxima questão',
        desabilitado: store.botaoOcupado,
        onPressed: () async {
          try {
            store.botaoOcupado = true;

            widget.provaStore.tempoCorrendo = EnumTempoStatus.PARADO;

            if (questao.tipo == EnumTipoQuestao.RESPOSTA_CONTRUIDA) {
              await widget.provaStore.respostas.definirResposta(
                questao.id,
                textoResposta: await controller.getText(),
                tempoQuestao: widget.provaStore.segundos,
              );
            }
            if (questao.tipo == EnumTipoQuestao.MULTIPLA_ESCOLHA) {
              await widget.provaStore.respostas.definirTempoResposta(
                questao.id,
                tempoQuestao: widget.provaStore.segundos,
              );
            }
            await SincronizarRespostasWorker().sincronizar();
            widget.provaStore.segundos = 0;

            listaQuestoesController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
            store.questaoAtual++;
          } catch (e) {
            fine(e);
          } finally {
            store.botaoOcupado = false;
          }
        },
      );
    }

    return BotaoDefaultWidget(
      textoBotao: 'Finalizar prova',
      onPressed: () async {
        store.questaoAtual = 0;
        try {
          widget.provaStore.tempoCorrendo = EnumTempoStatus.PARADO;
          await widget.provaStore.respostas.definirTempoResposta(
            questao.id,
            tempoQuestao: widget.provaStore.segundos,
          );
          widget.provaStore.segundos = 0;

          await _iniciarRevisaoProva();
        } catch (e) {
          fine(e);
        }
      },
    );
  }

  Widget _buildBotoes(Questao questao) {
    Widget botoesRespondendoProva = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildBotaoVoltar(questao),
        _buildBotaoProximo(questao),
      ],
    );

    if (kIsMobile) {
      botoesRespondendoProva = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBotaoVoltar(questao),
          _buildBotaoProximo(questao),
        ],
      );
    }

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
                if (store.posicaoQuestaoSendoRevisada != store.totalDeQuestoesParaRevisar) {
                  return BotaoDefaultWidget(
                    textoBotao: 'Proximo item da revisão',
                    onPressed: () async {
                      store.revisandoProva = true;
                      store.posicaoQuestaoSendoRevisada++;
                      listaQuestoesController.animateToPage(
                        store.posicaoQuestaoSendoRevisada,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
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
                  widget.provaStore.tempoCorrendo = EnumTempoStatus.PARADO;
                  await widget.provaStore.respostas.definirTempoResposta(
                    questao.id,
                    tempoQuestao: widget.provaStore.segundos,
                  );
                  await SincronizarRespostasWorker().sincronizar();
                  int posicaoDaQuestao = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResumoRespostasView(
                        provaStore: widget.provaStore,
                      ),
                    ),
                  );

                  store.posicaoQuestaoSendoRevisada = posicaoDaQuestao;

                  store.revisandoProva = true;
                  store.questaoAtual = posicaoDaQuestao;
                  listaQuestoesController.jumpToPage(
                    posicaoDaQuestao,
                  );
                } catch (e) {
                  fine(e);
                } finally {
                  store.botaoOcupado = false;
                }
              },
            ),
          ],
        ),
      );
    } else {
      return botoesRespondendoProva;
    }
  }

  String tratarArquivos(String texto, List<Arquivo> arquivos) {
    texto = texto.replaceAllMapped(RegExp(r'(<img[^>]*>)'), (match) {
      return '<div style="text-align: center; position:relative">${match.group(0)}<p><span>Toque na imagem para ampliar</span></p></div>';
    });

    for (var arquivo in arquivos) {
      var obterTipo = arquivo.caminho.split(".");
      texto =
          texto.replaceAll("#${arquivo.id}#", "data:image/${obterTipo[obterTipo.length - 1]};base64,${arquivo.base64}");
    }

    texto = texto.replaceAll("#0#", AssetsUtil.notfound);

    return texto;
  }

  _buildTempoProva() {
    if (widget.provaStore.tempoExecucaoStore == null) {
      return [SizedBox.shrink()];
    }

    return [
      Observer(builder: (_) {
        return BarraProgresso(
          progresso: widget.provaStore.tempoExecucaoStore?.porcentagem ?? 0,
          tempoRestante: widget.provaStore.tempoExecucaoStore?.tempoRestante ?? Duration(),
          variant: widget.provaStore.tempoExecucaoStore?.status,
          alerta: store.mostrarAlertaDeTempoAcabando,
        );
      }),
      Observer(builder: (_) {
        return Visibility(
          visible: store.mostrarAlertaDeTempoAcabando,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TemaUtil.laranja01,
            ),
            child: Center(
              child: Texto(
                'Atenção: ${formatDuration(widget.provaStore.tempoExecucaoStore!.tempoRestante)} restantes',
                bold: true,
                fontSize: 16,
                color: TemaUtil.preto,
              ),
            ),
          ),
        );
      }),
    ];
  }

  Future<void> _iniciarRevisaoProva() async {
    await SincronizarRespostasWorker().sincronizar();

    store.revisandoProva = true;

    if (widget.provaStore.foraDaPaginaDeRevisao) {
      widget.provaStore.foraDaPaginaDeRevisao = false;
      int? posicaoDaQuestao = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResumoRespostasView(
            provaStore: widget.provaStore,
          ),
        ),
      );

      if (posicaoDaQuestao != null) {
        store.posicaoQuestaoSendoRevisada = posicaoDaQuestao;
        store.revisandoProva = true;
        listaQuestoesController.jumpToPage(
          store.posicaoQuestaoSendoRevisada,
        );
      }
    }
  }
}
