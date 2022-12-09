import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/stores/questao_tai_view.store.dart';
import 'package:appserap/ui/views/prova/prova.media.util.dart';
import 'package:appserap/ui/views/prova/widgets/questao_aluno.widget.dart';
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
  void initState() {
    super.initState();
    store.carregarQuestao(widget.provaId);
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

      return _buildProva();
    });
  }

  Widget _buildProva() {
    return Stack(
      children: [
        _buildAudioPlayer(),
        _buildLayout(
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildSumario(),
                _buildQuestao(),
                _buildBotoes(),
              ],
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
      audioPath: store.response!.audios.first.caminho,
    );
  }

  _buildSumario() {
    return Row(
      children: [
        Texto(
          'Questão ${store.response!.ordem + 1} ',
          color: TemaUtil.preto,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        Texto(
          'de ${store.provaStore!.prova.formatoTaiItem}',
          color: TemaUtil.preto,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildQuestao() {
    return QuestaoAlunoWidget(
      controller: controller,
      provaStore: store.provaStore!,
      questaoId: store.response!.id,
      questao: store.response!.getQuestaoResponseDTO().toModel(),
      imagens: store.response!.arquivos.map((e) => e.toModel()).toList(),
      alternativas: store.response!.alternativas.map((e) => e.toModel()).toList(),
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
      videoUrl: store.response!.videos.first.caminho,
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

    if (kIsMobile || kIsTablet && store.response!.videos.isNotEmpty) {
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
    if (store.response!.ordem == 0 || store.provaStore!.prova.formatoTaiVoltarItemAnterior) {
      return SizedBox.shrink();
    }

    return BotaoSecundarioWidget(
      textoBotao: 'Questão anterior',
      onPressed: () async {},
    );
  }

  Widget _buildBotaoProximo() {
    return BotaoDefaultWidget(
      textoBotao: 'Próxima questão',
      onPressed: () async {},
    );

    return _buildBotaoFinalizarProva();
  }

  Widget _buildBotaoFinalizarProva() {
    return BotaoDefaultWidget(
      textoBotao: 'Finalizar prova',
      onPressed: () async {},
    );
  }

  bool exibirAudio() {
    if (store.response!.audios.isEmpty) {
      return false;
    }

    return verificarDeficienciaVisual();
  }

  bool exibirVideo() {
    if (store.response!.videos.isEmpty) {
      return false;
    }

    return verificarDeficienciaAuditiva();
  }
}
