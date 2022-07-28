import 'dart:convert';
import 'dart:typed_data';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tempo_status.enum.dart';
import 'package:appserap/enums/tipo_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/models/resposta_prova.model.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/questao_revisao.store.dart';
import 'package:appserap/ui/views/prova/widgets/tempo_execucao.widget.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/audio_player/audio_player.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/file.util.dart';
import 'package:appserap/utils/idb_file.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:flutter/foundation.dart';
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
  late List<Alternativa> alternativas;
  late List<Arquivo> imagens;

  ArquivoAudioDb? arquivoAudioDb;

  var db = ServiceLocator.get<AppDatabase>();

  final controller = HtmlEditorController();

  @override
  void initState() {
    super.initState();
    store.isLoading = true;

    configure().then((_) {
      store.isLoading = false;
    });

    provaStore.tempoCorrendo = EnumTempoStatus.CORRENDO;
  }

  Future<void> configure() async {
    var provas = ServiceLocator.get<HomeStore>().provas;

    if (provas.isEmpty) {
      ServiceLocator.get<AppRouter>().router.go("/");
    }

    provaStore = provas.filter((prova) => prova.key == widget.idProva).first.value;
    questao = await db.questaoDao.getByProvaEOrdem(widget.idProva, widget.ordem, provaStore.caderno);
    alternativas = await db.alternativaDao.obterPorQuestaoId(questao.id);
    imagens = await db.arquivoDao.obterPorQuestaoId(questao.id);
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

    return Observer(builder: (_) {
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

      return Column(
        children: [
          TempoExecucaoWidget(provaStore: provaStore),
          _buildAudioPlayer(),
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
                                  'de ${provaStore.prova.itensQuantidade}',
                                  style: TemaUtil.temaTextoNumeroQuestoesTotal.copyWith(
                                    fontSize: temaStore.tTexto20,
                                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Html(
                              data: tratarArquivos(questao.titulo, imagens, EnumTipoImagem.QUESTAO),
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
                              data: tratarArquivos(questao.descricao, imagens, EnumTipoImagem.QUESTAO),
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
    });
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
                  child: Html(
                    data: tratarArquivos(descricao, imagens, EnumTipoImagem.ALTERNATIVA),
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

  String tratarArquivos(String? texto, List<Arquivo> arquivos, EnumTipoImagem tipoImagem) {
    if (texto == null) {
      return "";
    }

    if (tipoImagem == EnumTipoImagem.QUESTAO) {
      texto = texto.replaceAllMapped(RegExp(r'(<img[^>]*>)'), (match) {
        return '<div style="text-align: center; position:relative">${match.group(0)}<p><span>Toque na imagem para ampliar</span></p></div>';
      });
    }

    for (var arquivo in arquivos) {
      var obterTipo = arquivo.caminho.split(".");
      texto = texto!.replaceAll(
          "#${arquivo.legadoId}#", "data:image/${obterTipo[obterTipo.length - 1]};base64,${arquivo.base64}");
    }

    texto = texto!.replaceAll("#0#", AssetsUtil.notfound);

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
                textoBotao: 'Próximo item da revisão',
                onPressed: () async {
                  try {
                    if (store.botaoOcupado) return;

                    store.botaoOcupado = true;

                    provaStore.tempoCorrendo = EnumTempoStatus.PARADO;
                    await provaStore.respostas.definirTempoResposta(
                      questao.id,
                      tempoQuestao: provaStore.segundos,
                    );

                    await provaStore.respostas.sincronizarResposta();
                    store.posicaoQuestaoSendoRevisada++;
                    context.push("/prova/${widget.idProva}/revisao/${store.posicaoQuestaoSendoRevisada}");
                  } catch (e, stack) {
                    await recordError(e, stack);
                  } finally {
                    store.botaoOcupado = false;
                  }
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

              await provaStore.respostas.sincronizarResposta();

              context.go("/prova/${provaStore.id}/resumo");
            } catch (e, stack) {
              await recordError(e, stack);
            } finally {
              store.botaoOcupado = false;
            }
          },
        ),
      ],
    );
  }

  Future<Uint8List?> loadAudio(Questao questao) async {
    arquivoAudioDb = await db.arquivosAudioDao.obterPorQuestaoId(questao.id);

    if (arquivoAudioDb != null) {
      IdbFile idbFile = IdbFile(arquivoAudioDb!.path);

      if (await idbFile.exists()) {
        Uint8List readContents = Uint8List.fromList(await idbFile.readAsBytes());
        info('abrindo audio ${formatBytes(readContents.lengthInBytes, 2)}');
        return readContents;
      }
    }
  }

  Widget _buildAudioPlayer() {
    if (kIsWeb) {
      return FutureBuilder<Uint8List?>(
        future: loadAudio(questao),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AudioPlayerWidget(
              audioBytes: snapshot.data,
            );
          }

          return SizedBox.shrink();
        },
      );
    } else {
      if (arquivoAudioDb != null) {
        return AudioPlayerWidget(
          audioPath: arquivoAudioDb!.path,
        );
      }
    }

    return SizedBox.shrink();
  }
}
