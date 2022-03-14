import 'package:appserap/dtos/admin_prova_resumo.response.dto.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/stores/admin_prova_questao.store.dart';
import 'package:appserap/ui/views/prova/widgets/questao_admin.widget.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/audio_player/audio_player.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/video_player/video_player.widget.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class AdminProvaQuestaoView extends BaseStatefulWidget {
  final int idProva;
  final String? nomeCaderno;
  final int ordem;
  final List<AdminProvaResumoResponseDTO> resumo;

  AdminProvaQuestaoView({
    Key? key,
    required this.idProva,
    this.nomeCaderno,
    required this.ordem,
    required this.resumo,
  }) : super(key: key);

  @override
  State<AdminProvaQuestaoView> createState() => _AdminProvaQuestaoViewState();
}

class _AdminProvaQuestaoViewState extends BaseStateWidget<AdminProvaQuestaoView, AdminProvaQuestaoViewStore> {
  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  void initState() {
    super.initState();
    store.carregarDetalhesQuestao(widget.idProva, widget.resumo.firstWhere((e) => e.ordem == widget.ordem).id);
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      leading: _buildBotaoVoltarLeading(context),
    );
  }

  Widget? _buildBotaoVoltarLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        if (widget.nomeCaderno != null) {
          context.go("/admin/prova/${widget.idProva}/caderno/${widget.nomeCaderno}/resumo");
        } else {
          context.go("/admin/prova/${widget.idProva}/resumo");
        }
      },
    );
  }

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

      return Column(
        children: [
          _buildAudioPlayer(),
          Expanded(
            child: _builLayout(
              body: SingleChildScrollView(
                child: Padding(
                  padding: exibirVideo() ? EdgeInsets.zero : getPadding(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: exibirVideo() ? MediaQuery.of(context).size.width * 0.5 : null,
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
                                QuestaoAdminWidget(
                                    questao: store.questao!, imagens: store.imagens, alternativas: store.alternativas),
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
                        child: _buildBotoes(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  _builLayout({required Widget body}) {
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

    return AudioPlayerWidget(
      audioPath: store.audios.first.caminho,
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
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

    if (kIsMobile || kIsTablet && store.videos.isNotEmpty) {
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
      textoBotao: 'Item anterior',
      onPressed: () async {
        context.push("/admin/prova/${widget.idProva}/questao/${widget.ordem - 1}", extra: widget.resumo.toList());
      },
    );
  }

  Widget _buildBotaoProximo() {
    if (widget.ordem < widget.resumo.length - 1) {
      return BotaoDefaultWidget(
        textoBotao: 'Próximo item',
        onPressed: () async {
          context.push("/admin/prova/${widget.idProva}/questao/${widget.ordem + 1}", extra: widget.resumo.toList());
        },
      );
    }

    return BotaoDefaultWidget(
      textoBotao: 'Voltar para o resumo',
      onPressed: () async {
        if (widget.nomeCaderno != null) {
          context.go("/admin/prova/${widget.idProva}/caderno/${widget.nomeCaderno}/resumo");
        } else {
          context.go("/admin/prova/${widget.idProva}/resumo");
        }
      },
    );
  }

  Future<Widget> showVideoPlayer() async {
    return VideoPlayerWidget(videoUrl: store.videos.first.caminho);
  }

  bool exibirAudio() {
    if (store.audios.isEmpty) {
      return false;
    }

    return true;
  }

  bool exibirVideo() {
    if (store.videos.isEmpty) {
      return false;
    }

    return true;
  }
}
