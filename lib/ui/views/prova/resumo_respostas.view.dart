import 'package:appserap/enums/tempo_status.enum.dart';
import 'package:appserap/stores/prova_tempo_exeucao.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart';
import 'package:appserap/ui/widgets/barras/barra_progresso.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:get_it/get_it.dart';

class ResumoRespostasView extends BaseStatefulWidget {
  const ResumoRespostasView({
    required this.provaStore,
  }) : super(title: "Resumo das respostas");
  final ProvaStore provaStore;

  @override
  _ResumoRespostasViewState createState() => _ResumoRespostasViewState();
}

class _ResumoRespostasViewState extends BaseStateWidget<ResumoRespostasView, ProvaViewStore> with Loggable {
  List<Map<String, dynamic>> mapaDeQuestoes = [];
  List<TableRow> questoesTabela = [];

  final temaStore = GetIt.I.get<TemaStore>();

  @override
  void initState() {
    super.initState();
    widget.provaStore.foraDaPaginaDeRevisao = false;
    popularMapaDeQuestoes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  double get defaultPadding => 0;

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      subtitulo: widget.provaStore.prova.descricao,
      mostrarBotaoVoltar: false,
    );
  }

  @override
  Widget builder(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SingleChildScrollView(
        child: Observer(
          builder: (_) {
            return Column(
              children: [
                ..._buildTempoProva(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //
                      Observer(
                        builder: (_) {
                          return Text(
                            'Resumo das respostas',
                            textAlign: TextAlign.start,
                            style: TemaUtil.temaTextoNumeroQuestoes.copyWith(
                              fontSize: temaStore.tTexto20,
                              fontFamily: temaStore.fonteDoTexto,
                            ),
                          );
                        },
                      ),
                      //
                      Observer(
                        builder: (context) {
                          return mensagemDeQuestoesSemRespostas();
                        },
                      ),
                      //
                      Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: {
                          0: FractionColumnWidth(.65),
                          1: FractionColumnWidth(.2),
                          2: FractionColumnWidth(.15),
                        },
                        children: questoesTabela,
                      ),
                      SizedBox(height: 32),
                      Center(
                        child: BotaoDefaultWidget(
                          textoBotao: 'FINALIZAR E ENVIAR',
                          largura: 392,
                          onPressed: () async {
                            await finalizarProva();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String tratarTexto(String texto) {
    RegExp r = RegExp(r"<[^>]*>");
    String textoNovo = texto.replaceAll(r, '');
    textoNovo = textoNovo.replaceAll('\n', ' ').replaceAll(':', ': ');
    return textoNovo;
  }

  void popularMapaDeQuestoes() {
    store.quantidadeDeQuestoesSemRespostas = 0;
    store.questoesParaRevisar.clear();

    for (Questao questao in widget.provaStore.prova.questoes) {
      ProvaResposta? resposta = widget.provaStore.respostas.obterResposta(questao.id);

      String alternativaSelecionada = "";
      String respostaNaTela = "";
      String questaoProva = tratarTexto(questao.titulo) + tratarTexto(questao.descricao);

      if (questaoProva.length >= 45) {
        questaoProva = questaoProva.substring(0, 45) + '...';
      }

      String ordemQuestaoTratada = questao.ordem < 10 ? '0${questao.ordem + 1}' : '${questao.ordem + 1}';

      if (questao.id == resposta?.questaoId) {
        for (var alternativa in questao.alternativas) {
          if (alternativa.id == resposta!.alternativaId) {
            alternativaSelecionada = alternativa.numeracao;
          }
        }

        bool podeAdicionarRespostaVazia = (resposta!.resposta == null ||
                resposta.resposta!.isEmpty ||
                alternativaSelecionada.isEmpty) &&
            (widget.provaStore.tempoExecucaoStore != null && !widget.provaStore.tempoExecucaoStore!.isTempoExtendido);

        bool removeQuestaoQueNaoPodeRevisar = (resposta.resposta == null ||
                resposta.resposta!.isEmpty ||
                alternativaSelecionada.isEmpty) &&
            (widget.provaStore.tempoExecucaoStore != null && !widget.provaStore.tempoExecucaoStore!.isTempoExtendido);

        if (alternativaSelecionada.isNotEmpty) {
          respostaNaTela = alternativaSelecionada;
          store.questoesParaRevisar.add(questao);
        } else if (resposta.resposta != null && resposta.resposta!.isNotEmpty) {
          respostaNaTela = "OK";
          store.questoesParaRevisar.add(questao);
        } else if (podeAdicionarRespostaVazia) {
          store.questoesParaRevisar.add(questao);
          store.quantidadeDeQuestoesSemRespostas++;
        } else if (removeQuestaoQueNaoPodeRevisar) {
          store.questoesParaRevisar.remove(questao);
          store.quantidadeDeQuestoesSemRespostas++;
        }
      } else {
        store.quantidadeDeQuestoesSemRespostas++;
      }

      mapaDeQuestoes.add(
        {
          'questao': '$ordemQuestaoTratada - $questaoProva',
          'resposta': respostaNaTela,
          'questao_ordem': questao.ordem,
        },
      );

      mapaDeQuestoes.sort(
        (questao1, questao2) {
          return questao1['questao_ordem'].compareTo(
            questao2['questao_ordem'],
          );
        },
      );

      popularTabelaComQuestoes();
    }
  }

  Widget mensagemDeQuestoesSemRespostas() {
    if (store.quantidadeDeQuestoesSemRespostas > 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Observer(
          builder: (_) {
            return Row(
              children: [
                //
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    AssetsUtil.iconeQuestaoNaoRespondida,
                  ),
                ),
                //
                store.quantidadeDeQuestoesSemRespostas > 1
                    ? Text(
                        "${store.quantidadeDeQuestoesSemRespostas} Questões sem resposta",
                        style: TemaUtil.temaTextoQuestaoSemResposta.copyWith(
                          fontSize: temaStore.tTexto14,
                          fontFamily: temaStore.fonteDoTexto,
                        ),
                      )
                    : Text(
                        "${store.quantidadeDeQuestoesSemRespostas} Questão sem resposta",
                        style: TemaUtil.temaTextoQuestaoSemResposta.copyWith(
                          fontSize: temaStore.tTexto14,
                          fontFamily: temaStore.fonteDoTexto,
                        ),
                      )
              ],
            );
          },
        ),
      );
    } else {
      return SizedBox(
        height: 40,
      );
    }
  }

  List<TableRow> popularTabelaComQuestoes() {
    List<TableRow> linhas = [];

    for (var questao in mapaDeQuestoes) {
      Widget resposta;
      if (questao['resposta'] != "") {
        resposta = Center(
          child: Observer(
            builder: (context) {
              return Text(
                questao['resposta'].replaceAll(")", ""),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: temaStore.tTexto14,
                  fontFamily: temaStore.fonteDoTexto,
                ),
              );
            },
          ),
        );
      } else {
        resposta = SvgPicture.asset(
          AssetsUtil.iconeQuestaoNaoRespondida,
        );
      }

      linhas.add(
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: TemaUtil.pretoSemFoco2,
                style: BorderStyle.solid,
              ),
            ),
          ),
          children: [
            //
            Observer(
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    questao['questao'],
                    style: TextStyle(
                      fontSize: temaStore.tTexto12,
                      fontFamily: temaStore.fonteDoTexto,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: resposta,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                onTap: () {
                  widget.provaStore.tempoCorrendo = EnumTempoStatus.CORRENDO;
                  if (!widget.provaStore.tempoExecucaoStore!.isTempoExtendido && questao['resposta'] == "") {
                    store.quantidadeDeQuestoesSemRespostas = 0;
                    Navigator.of(context).pop(questao['questao_ordem']);
                  } else if (questao['resposta'] != "") {
                    store.quantidadeDeQuestoesSemRespostas = 0;
                    Navigator.of(context).pop(questao['questao_ordem']);
                  }
                },
                child: SvgPicture.asset(
                  AssetsUtil.iconeRevisarQuestao,
                ),
              ),
            ),
          ],
        ),
      );
    }

    questoesTabela = linhas;

    questoesTabela.insert(
      0,
      TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TemaUtil.pretoSemFoco2,
              style: BorderStyle.solid,
            ),
          ),
        ),
        children: [
          //
          Observer(
            builder: (_) {
              return Text(
                "Questão",
                style: TemaUtil.temaTextoTabelaResumo.copyWith(
                  fontSize: temaStore.tTexto14,
                  fontFamily: temaStore.fonteDoTexto,
                ),
              );
            },
          ),
          Observer(
            builder: (_) {
              return Text(
                "Alternativa selecionada",
                style: TemaUtil.temaTextoTabelaResumo.copyWith(
                  fontSize: temaStore.tTexto14,
                  fontFamily: temaStore.fonteDoTexto,
                ),
              );
            },
          ),
          Observer(
            builder: (_) {
              return Text(
                "Revisar",
                style: TemaUtil.temaTextoTabelaResumo.copyWith(
                  fontSize: temaStore.tTexto14,
                  fontFamily: temaStore.fonteDoTexto,
                ),
              );
            },
          ),
        ],
      ),
    );

    return questoesTabela;
  }

  finalizarProva() async {
    bool finalizar = true;

    finalizar = await checarFinalizacaoComTempo();

    if (finalizar) {
      await widget.provaStore.finalizarProva(context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashScreenView()),
        (_) => false,
      );
    }
  }

  Future<bool> checarFinalizacaoComTempo() async {
    ProvaTempoExecucaoStore? tempoExecucaoStore = widget.provaStore.tempoExecucaoStore;
    if (tempoExecucaoStore != null) {
      bool possuiTempoNormalRestante =
          tempoExecucaoStore.isTempoNormalEmExecucao && tempoExecucaoStore.possuiTempoRestante;

      if (possuiTempoNormalRestante) {
        return (await mostrarDialogAindaPossuiTempo(
          context,
          widget.provaStore.tempoExecucaoStore!.tempoRestante,
        ))!;
      }
    }

    return true;
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
              child: Observer(builder: (_) {
                return Texto(
                  'Atenção: ${formatDuration(widget.provaStore.tempoExecucaoStore!.tempoRestante)} restantes',
                  bold: true,
                  fontSize: temaStore.tTexto16,
                  color: TemaUtil.preto,
                );
              }),
            ),
          ),
        );
      }),
    ];
  }
}
