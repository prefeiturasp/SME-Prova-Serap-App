// ignore_for_file: unused_import

import 'dart:convert';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tempo_status.enum.dart';
import 'package:appserap/enums/tipo_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/main.route.gr.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/models/resposta_prova.model.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/questao_revisao.store.dart';
import 'package:appserap/ui/views/prova/prova.view.util.dart';
import 'package:appserap/ui/views/prova/widgets/questao_aluno.widget.dart';
import 'package:appserap/ui/views/prova/widgets/tempo_execucao.widget.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/player_audio/player_audio_widget.dart';
import 'package:appserap/ui/widgets/status_sincronizacao/status_sincronizacao.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/file.util.dart';
import 'package:appserap/utils/idb_file.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:appserap/utils/universal/universal.util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:photo_view/photo_view.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

import '../../widgets/video_player/video_player.widget.dart';

@RoutePage()
class QuestaoRevisaoView extends BaseStatefulWidget {
  final int idProva;
  final int ordem;

  QuestaoRevisaoView({
    Key? key,
    @PathParam('idProva') required this.idProva,
    @PathParam('ordem') required this.ordem,
  }) : super(key: key);

  @override
  _QuestaoRevisaoViewState createState() => _QuestaoRevisaoViewState();
}

class _QuestaoRevisaoViewState extends BaseStateWidget<QuestaoRevisaoView, QuestaoRevisaoStore>
    with Loggable, ProvaViewUtil {
  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  double get defaultPadding => 0;

  late ProvaStore provaStore;
  late Questao questao;
  late List<Alternativa> alternativas;
  late List<Arquivo> imagens;
  late Uint8List arquivoVideo;
  late Uint8List arquivoAudio;
  late int questaoId;

  ArquivoVideoDb? arquivoVideoDb;
  ArquivoAudioDb? arquivoAudioDb;

  var db = sl<AppDatabase>();

  final controller = HtmlEditorController();

  @override
  AppBarWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      subtitulo: provaStore.prova.descricao,
    );
  }

  @override
  void initState() {
    super.initState();
    store.isLoading = true;

    configure().then((_) {
      store.isLoading = false;
      provaStore.tempoCorrendo = EnumTempoStatus.CORRENDO;
    });
  }

  configure() async {
    var provas = sl<HomeStore>().provas;

    if (provas.isEmpty) {
      sl<AppRouter>().navigate(HomeViewRoute());
      return;
    }

    provaStore = provas.filter((prova) => prova.key == widget.idProva).first.value;

    await _carregarProva();
    await _carregarArquivos();
  }

  _carregarProva() async {
    questao = await db.questaoDao.getByProvaEOrdem(
      widget.idProva,
      provaStore.caderno,
      widget.ordem,
    );
    alternativas = await db.alternativaDao.obterPorQuestaoLegadoId(
      questao.questaoLegadoId,
    );
    imagens = await db.arquivoDao.obterPorQuestaoLegadoId(
      questao.questaoLegadoId,
    );
    questaoId = await db.provaCadernoDao.obterQuestaoIdPorProvaECadernoEOrdem(
      widget.idProva,
      provaStore.caderno,
      widget.ordem,
    );
  }

  _carregarArquivos() async {
    if (provaStore.prova.exibirAudio) {
      await loadAudio(questao);
    }

    if (provaStore.prova.exibirVideo) {
      await loadVideos(questao);
    }
  }

  Future<void> loadVideos(Questao questao) async {
    arquivoVideoDb = await db.arquivosVideosDao.findByQuestaoLegadoId(questao.questaoLegadoId);

    if (arquivoVideoDb != null && kIsWeb) {
      IdbFile idbFile = IdbFile(arquivoVideoDb!.path);

      if (await idbFile.exists()) {
        Uint8List readContents = Uint8List.fromList(await idbFile.readAsBytes());
        info('abrindo video ${formatBytes(readContents.lengthInBytes, 2)}');
        arquivoVideo = readContents;
      }
    }
  }

  Future<void> loadAudio(Questao questao) async {
    arquivoAudioDb = await db.arquivosAudioDao.obterPorQuestaoLegadoId(questao.questaoLegadoId);

    if (arquivoAudioDb != null && kIsWeb) {
      IdbFile idbFile = IdbFile(arquivoAudioDb!.path);

      if (await idbFile.exists()) {
        Uint8List readContents = Uint8List.fromList(await idbFile.readAsBytes());
        info('abrindo audio ${formatBytes(readContents.lengthInBytes, 2)}');
        arquivoAudio = readContents;
      }
    }
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

      return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            TempoExecucaoWidget(provaStore: provaStore),
            _buildAudioPlayer(),
            StatusSincronizacao(),
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
                                        'de ${provaStore.prova.itensQuantidade}',
                                        style: TemaUtil.temaTextoNumeroQuestoesTotal.copyWith(
                                          fontSize: temaStore.tTexto20,
                                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  QuestaoAlunoWidget(
                                    provaStore: provaStore,
                                    controller: controller,
                                    questaoId: questaoId,
                                    questao: questao,
                                    alternativas: alternativas,
                                    imagens: imagens,
                                  ),
                                  SizedBox(height: 8),
                                ],
                              ),
                            );
                          }),
                        ),
                        Observer(builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              bottom: 20,
                            ),
                            child: Column(
                              children: [
                                // kDebugMode ? _buildBotaoFinalizarProva() : Container(),
                                _buildBotoes(questao),
                              ],
                            ),
                          );
                        }),
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

  Widget _buildBotoes(Questao questao) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildBotaoProximaQuestao(),
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
                questaoId,
                tempoQuestao: provaStore.segundos,
              );

              await provaStore.respostas.sincronizarResposta();
              provaStore.ultimaAtualizacaoLogImagem = null;

              context.router.replace(ResumoRespostasViewRoute(idProva: provaStore.id));
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

  Widget _buildBotaoProximaQuestao() {
    List<MapEntry<int, Questao>> listaQuestoes = store.questoesParaRevisar.entries.toList();

    int? ordemProximaQuestao;

    for (var i = 0; i < listaQuestoes.length; i++) {
      if (listaQuestoes[i].value.questaoLegadoId == questao.questaoLegadoId) {
        if (i + 1 < listaQuestoes.length) {
          ordemProximaQuestao = listaQuestoes[i + 1].key;
        }
      }
    }

    if (ordemProximaQuestao == null || ordemProximaQuestao == widget.ordem) {
      return Container();
    }

    return BotaoDefaultWidget(
      textoBotao: 'Próximo item da revisão',
      onPressed: () async {
        try {
          if (store.botaoOcupado) return;

          store.botaoOcupado = true;

          provaStore.tempoCorrendo = EnumTempoStatus.PARADO;
          await provaStore.respostas.definirTempoResposta(
            questaoId,
            tempoQuestao: provaStore.segundos,
          );

          await provaStore.respostas.sincronizarResposta();
          store.posicaoQuestaoSendoRevisada++;
          provaStore.ultimaAtualizacaoLogImagem = null;

          context.router.navigate(
            QuestaoRevisaoViewRoute(
              key: ValueKey("${widget.idProva}-$ordemProximaQuestao"),
              idProva: widget.idProva,
              ordem: ordemProximaQuestao!,
            ),
          );
        } catch (e, stack) {
          await recordError(e, stack);
        } finally {
          store.botaoOcupado = false;
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
    if (provaStore.prova.exibirAudio) {
      if (arquivoAudioDb != null) {
        return true;
      }
    }

    return false;
  }

  bool exibirVideo() {
    if (provaStore.prova.exibirVideo) {
      if (arquivoVideoDb != null) {
        return true;
      }
    }

    return false;
  }
}
