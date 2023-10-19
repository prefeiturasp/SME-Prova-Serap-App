import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.gr.dart';
import 'package:appserap/stores/questao_resultado_detalhes_view.store.dart';
import 'package:appserap/ui/views/prova/widgets/questao_aluno_resposta.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/player_audio/player_audio_widget.dart';
import 'package:appserap/ui/widgets/video_player/video_player.widget.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/utils/universal/universal.util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:html_editor_enhanced/html_editor.dart';

@RoutePage()
class QuestaoResultadoDetalhesView extends BaseStatefulWidget {
  final int provaId;
  final String caderno;
  final int ordem;

  const QuestaoResultadoDetalhesView({
    super.key,
    @PathParam('idProva') required this.provaId,
    @PathParam('caderno') required this.caderno,
    @PathParam('ordem') required this.ordem,
  });

  @override
  State<QuestaoResultadoDetalhesView> createState() => _QuestaoResultadoDetalhesViewState();
}

class _QuestaoResultadoDetalhesViewState
    extends BaseStateWidget<QuestaoResultadoDetalhesView, QuestaoResultadoDetalhesViewStore> {
  late Uint8List arquivoVideo;
  late Uint8List arquivoAudio;

  ArquivoVideoDb? arquivoVideoDb;
  ArquivoAudioDb? arquivoAudioDb;

  var db = sl<AppDatabase>();

  final controller = HtmlEditorController();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    store.carregarDetalhesQuestao(
      provaId: widget.provaId,
      caderno: widget.caderno,
      ordem: widget.ordem,
    );
  }

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  double get defaultPadding => 0;

  @override
  Widget builder(BuildContext context) {
    return Observer(builder: (context) {
      if (store.carregando) {
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

      return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            _buildAudioPlayer(),
            Expanded(
              child: _buildLayout(
                body: Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  controller: _controller,
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Padding(
                      padding: exibirVideo() ? EdgeInsets.zero : getPadding(),
                      child: Column(
                        children: [
                          SizedBox(
                            width: exibirVideo() ? MediaQuery.of(context).size.width / 2 : null,
                            child: Observer(builder: (_) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Questão ${widget.ordem + 1} ',
                                          style: TemaUtil.temaTextoNumeroQuestoes.copyWith(
                                            fontSize: temaStore.tTexto20,
                                            fontFamily: temaStore.fonteDoTexto.nomeFonte,
                                          ),
                                        ),
                                        Text(
                                          'de ${store.totalQuestoes}',
                                          style: TemaUtil.temaTextoNumeroQuestoesTotal.copyWith(
                                            fontSize: temaStore.tTexto20,
                                            fontFamily: temaStore.fonteDoTexto.nomeFonte,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    QuestaoAlunoRespostaWidget(
                                      controller: controller,
                                      questao: store.questao!.toModel(),
                                      alternativas: store.alternativas.map((e) => e.toModel()).toList(),
                                      imagens: store.imagens.map((e) => e.toModel()).toList(),
                                      ordemAlternativaCorreta: store.detalhes!.ordemAlternativaCorreta,
                                      ordemAlternativaResposta: store.detalhes!.ordemAlternativaResposta,
                                      respostaConstruida: store.detalhes!.respostaConstruida,
                                    ),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              bottom: 20,
                            ),
                            child: Column(
                              children: [
                                // kDebugMode ? _buildBotaoFinalizarProva() : Container(),
                                _buildBotoes(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  _buildLayout({required Widget body}) {
    if (exibirVideo()) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: body,
          ),
          _buildVideoPlayer(),
        ],
      );
    } else {
      return body;
    }
  }

  Widget _buildAudioPlayer() {
    if (!exibirAudio()) {
      return SizedBox.shrink();
    }

    if (kIsWeb) {
      return PlayerAudioWidget(
        audioBytes: arquivoAudio,
      );
    } else {
      if (arquivoAudioDb != null) {
        return PlayerAudioWidget(
          audioPath: arquivoAudioDb!.path,
        );
      }
    }

    return SizedBox.shrink();
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.only(right: 16),
      child: FutureBuilder<Widget>(
        future: showVideoPlayer(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done ? snapshot.data! : Container();
        },
      ),
    );
  }

  Widget _buildBotoes() {
    Widget botoesRespondendoProva = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildBotaoVoltar(),
        _buildBotaoProximo(),
      ],
    );

    if (kIsMobile || kIsTablet && arquivoVideoDb != null) {
      botoesRespondendoProva = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBotaoVoltar(),
          _buildBotaoProximo(),
        ],
      );
    }

    return botoesRespondendoProva;
  }

  Widget _buildBotaoVoltar() {
    if (widget.ordem == 0) {
      return SizedBox.shrink();
    }

    return BotaoSecundarioWidget(
      textoBotao: 'Questão anterior',
      onPressed: () async {
        context.router.replace(
          QuestaoResultadoDetalhesViewRoute(
            key: ValueKey("${widget.provaId}-${widget.ordem - 1}"),
            provaId: widget.provaId,
            caderno: widget.caderno,
            ordem: widget.ordem - 1,
          ),
        );
      },
    );
  }

  Widget _buildBotaoProximo() {
    if (widget.ordem < store.totalQuestoes - 1) {
      return BotaoDefaultWidget(
        textoBotao: 'Próxima questão',
        onPressed: () async {
          context.router.replace(
            QuestaoResultadoDetalhesViewRoute(
              key: ValueKey("${widget.provaId}-${widget.ordem + 1}"),
              provaId: widget.provaId,
              caderno: widget.caderno,
              ordem: widget.ordem + 1,
            ),
          );
        },
      );
    }
    return _buildBotaoVoltarResumo();
  }

  Widget _buildBotaoVoltarResumo() {
    return BotaoDefaultWidget(
      textoBotao: 'Voltar ao resultado',
      onPressed: () async {
        try {
          context.router.push(ProvaResultadoResumoViewRoute(
            key: ValueKey(widget.provaId),
            provaId: widget.provaId,
            caderno: widget.caderno,
          ));
        } catch (e, stack) {
          await recordError(e, stack);
        }
      },
    );
  }

  Future<Widget> showVideoPlayer() async {
    if (kIsWeb) {
      return VideoPlayer(videoUrl: buildUrl(arquivoVideo));
    } else {
      String path = (await buildPath(arquivoVideoDb!.path))!;
      return VideoPlayer(videoPath: path);
    }
  }

  bool exibirAudio() {
    if (store.prova!.exibirAudio) {
      if (arquivoAudioDb != null) {
        return true;
      }
    }

    return false;
  }

  bool exibirVideo() {
    if (store.prova!.exibirVideo) {
      if (arquivoVideoDb != null) {
        return true;
      }
    }

    return false;
  }
}
