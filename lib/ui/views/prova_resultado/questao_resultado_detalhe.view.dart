import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/prova_resultado_resumo.response.dto.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/questao_resultado_detalhes_view.store.dart';
import 'package:appserap/ui/views/prova/prova.media.util.dart';
import 'package:appserap/ui/views/prova/widgets/questao_aluno_resposta.widget.dart';
import 'package:appserap/ui/widgets/audio_player/audio_player.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/video_player/video_player.widget.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/utils/universal/universal.util.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class QuestaoResultadoDetalhesView extends BaseStatefulWidget {
  final int provaId;
  final String caderno;
  final int ordem;
  final List<ProvaResultadoResumoResponseDto> resumo;

  const QuestaoResultadoDetalhesView({
    super.key,
    required this.provaId,
    required this.caderno,
    required this.ordem,
    required this.resumo,
  });

  @override
  State<QuestaoResultadoDetalhesView> createState() => _QuestaoResultadoDetalhesViewState();
}

class _QuestaoResultadoDetalhesViewState
    extends BaseStateWidget<QuestaoResultadoDetalhesView, QuestaoResultadoDetalhesViewStore> with ProvaMediaUtil {
  late Uint8List arquivoVideo;
  late Uint8List arquivoAudio;

  ArquivoVideoDb? arquivoVideoDb;
  ArquivoAudioDb? arquivoAudioDb;

  var db = ServiceLocator.get<AppDatabase>();

  final controller = HtmlEditorController();

  @override
  void initState() {
    super.initState();

    var questaoLegadoId = widget.resumo.where((element) => element.ordemQuestao == widget.ordem).first.idQuestaoLegado;
    store.carregarDetalhesQuestao(
      provaId: widget.provaId,
      questaoLegadoId: questaoLegadoId,
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
                body: SingleChildScrollView(
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
                                        'de ${widget.resumo.length}',
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
                                    imagens: store.imagens.map((e) => e.toArquivoModel()).toList(),
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
      return AudioPlayerWidget(
        audioBytes: arquivoAudio,
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
        context.replace(
          "/prova/resposta/${widget.provaId}/${widget.caderno}/${widget.ordem - 1}/detalhes",
          extra: widget.resumo.toList(),
        );
      },
    );
  }

  Widget _buildBotaoProximo() {
    if (widget.ordem < widget.resumo.length - 1) {
      return BotaoDefaultWidget(
        textoBotao: 'Próxima questão',
        onPressed: () async {
          context.replace(
            "/prova/resposta/${widget.provaId}/${widget.caderno}/${widget.ordem + 1}/detalhes",
            extra: widget.resumo.toList(),
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
          context.push("/prova/resposta/${widget.provaId}/${widget.caderno}/resumo");
        } catch (e, stack) {
          await recordError(e, stack);
        }
      },
    );
  }

  Future<Widget> showVideoPlayer() async {
    if (kIsWeb) {
      return VideoPlayerWidget(videoUrl: buildUrl(arquivoVideo));
    } else {
      String path = (await buildPath(arquivoVideoDb!.path))!;
      return VideoPlayerWidget(videoPath: path);
    }
  }

  bool exibirAudio() {
    if (arquivoAudioDb == null) {
      return false;
    }

    return verificarDeficienciaVisual();
  }

  bool exibirVideo() {
    if (arquivoVideoDb == null) {
      return false;
    }

    return verificarDeficienciaAuditiva();
  }
}
