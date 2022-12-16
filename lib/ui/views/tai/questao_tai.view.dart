import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/stores/questao_tai_view.store.dart';
import 'package:appserap/ui/views/prova/prova.media.util.dart';
import 'package:appserap/ui/views/prova/widgets/questao_tai.widget.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/audio_player/audio_player.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/ui/widgets/video_player/video_player.widget.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class QuestaoTaiView extends BaseStatefulWidget {
  final int provaId;

  const QuestaoTaiView({
    super.key,
    required this.provaId,
  });

  @override
  State<QuestaoTaiView> createState() => _QuestaoTaiViewState();
}

class _QuestaoTaiViewState extends BaseStateWidget<QuestaoTaiView, QuestaoTaiViewStore> with Loggable, ProvaMediaUtil {
  final controller = HtmlEditorController();

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  double get defaultPadding => 0;

  @override
  void initState() {
    super.initState();
    store.carregarQuestao(
      widget.provaId,
    );
  }

  @override
  AppBarWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      subtitulo: store.provaStore?.prova.descricao ?? "",
      leading: _buildLeading(),
    );
  }

  Widget? _buildLeading() {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        bool voltar = (await mostrarDialogVoltarProva(context)) ?? false;

        if (voltar) {
          context.go("/");
        }
      },
    );
  }

  @override
  Widget builder(BuildContext context) {
    return Observer(builder: (_) {
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

      if (!store.taiDisponivel) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Texto("Não é possível iniciar a prova pois não há conexão disponível."),
          ],
        );
      }

      return _buildProva();
    });
  }

  Widget _buildProva() {
    return Stack(
      children: [
        _buildAudioPlayer(),
        _buildLayout(
          body: SingleChildScrollView(
            child: Padding(
              padding: exibirVideo() ? EdgeInsets.zero : getPadding(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    _buildSumario(),
                    _buildQuestao(),
                    _buildBotoes(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioPlayer() {
    if (!exibirAudio()) {
      return SizedBox.shrink();
    }

    return AudioPlayerWidget(
      audioPath: store.questao!.audios.first.caminho,
    );
  }

  _buildSumario() {
    return Row(
      children: [
        Texto(
          'Questão ${store.questao!.ordem + 1} ',
          color: TemaUtil.preto,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildQuestao() {
    return QuestaoTaiWidget(
      controller: controller,
      provaStore: store.provaStore!,
      questaoId: store.questao!.id,
      questao: store.questao!.getQuestaoResponseDTO().toModel(),
      imagens: store.questao!.arquivos.map((e) => e.toModel()).toList(),
      alternativas: store.questao!.alternativas.map((e) => e.toModel()).toList(),
      alternativaIdResposta: store.alternativaIdMarcada,
      onRespostaChange: (alternativaId, texto) async {
        info("Definindo resposta $alternativaId");

        store.dataHoraResposta = clock.now();
        store.alternativaIdMarcada = alternativaId;
      },
    );
  }

  _buildLayout({required Widget body}) {
    if (exibirVideo()) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: body,
            ),
          ),
          SizedBox(width: 16),
          _buildVideoPlayer(),
        ],
      );
    } else {
      return body;
    }
  }

  Widget _buildVideoPlayer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: FutureBuilder<Widget>(
        future: showVideoPlayer(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done ? snapshot.data! : Container();
        },
      ),
    );
  }

  Future<Widget> showVideoPlayer() async {
    return VideoPlayerWidget(
      videoUrl: store.questao!.videos.first.caminho,
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

    if (kIsMobile || kIsTablet && store.questao!.videos.isNotEmpty) {
      botoesRespondendoProva = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBotaoVoltar(),
          _buildBotaoProximo(),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: botoesRespondendoProva,
    );
  }

  Widget _buildBotaoVoltar() {
    if (store.questao!.ordem == 0 || !store.provaStore!.prova.formatoTaiVoltarItemAnterior) {
      return SizedBox.shrink();
    }

    return BotaoSecundarioWidget(
      textoBotao: 'Questão anterior',
      onPressed: () async {},
    );
  }

  Widget _buildBotaoProximo() {
    return Observer(builder: (_) {
      return BotaoDefaultWidget(
        textoBotao: 'Próxima questão',
        desabilitado: store.botaoFinalizarOcupado,
        onPressed: () async {
          store.botaoFinalizarOcupado = true;
          bool continuar = await store.enviarResposta();

          if (!continuar) {
            context.go("/prova/tai/${widget.provaId}/resumo");
          } else {
            var ordem = store.questao!.ordem == 0 ? 1 : store.questao!.ordem + 1;
            context.go("/prova/tai/${widget.provaId}/questao/$ordem");
          }
          store.botaoFinalizarOcupado = false;
        },
      );
    });
  }

  bool exibirAudio() {
    if (store.questao!.audios.isEmpty) {
      return false;
    }

    return verificarDeficienciaVisual();
  }

  bool exibirVideo() {
    if (store.questao!.videos.isEmpty) {
      return false;
    }

    return verificarDeficienciaAuditiva();
  }
}
