import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tempo_status.enum.dart';
import 'package:appserap/stores/prova_tempo_exeucao.store.dart';
import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/widgets/barras/barra_progresso.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
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

  int flexQuestao = 18;
  int flexAlternativa = 4;
  int flexRevisao = 3;

  @override
  void initState() {
    super.initState();
    widget.provaStore.foraDaPaginaDeRevisao = false;
    popularMapaDeQuestoes();
  }

  @override
  void dispose() {
    widget.provaStore.setRespondendoProva(false);
    super.dispose();
  }

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  double get defaultPadding => 0;

  @override
  bool get willPop => false;

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
        child: Padding(
          padding: getPadding(),
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
                                fontFamily: temaStore.fonteDoTexto.nomeFonte,
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
                        Column(
                          children: [
                            _buildCabecalho(),
                            divider(),
                            ..._buildListaRespostas(),
                          ],
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
      ),
    );
  }

  _buildCabecalho() {
    List<Widget> rows = [];

    bool exibirRevisar = true;

    if (kIsMobile) {
      if (temaStore.incrementador > 16) {
        flexQuestao = 5;
        exibirRevisar = false;
      } else {
        flexQuestao = 8;
      }
    } else {
      if (temaStore.incrementador > 20) {
        flexQuestao = 14;
        flexAlternativa = 7;
        flexRevisao = 4;
      } else if (temaStore.incrementador > 18) {
        flexQuestao = 14;
        flexAlternativa = 6;
      } else if (temaStore.incrementador > 16) {
        flexQuestao = 15;
        flexAlternativa = 5;
      }
    }

    rows.add(
      Expanded(
        flex: flexQuestao,
        child: Texto(
          "Questão",
          fontSize: 14,
          color: TemaUtil.appBar,
        ),
      ),
    );

    rows.add(
      Flexible(
        flex: flexAlternativa,
        child: Center(
          child: Texto(
            "Alternativa selecionada",
            fontSize: 14,
            maxLines: 2,
            center: true,
            color: TemaUtil.appBar,
          ),
        ),
      ),
    );

    if (exibirRevisar) {
      rows.add(
        Flexible(
          flex: flexRevisao,
          child: Center(
            child: Texto(
              "Revisar",
              fontSize: 14,
              color: TemaUtil.appBar,
            ),
          ),
        ),
      );
    }

    return Row(children: rows);
  }

  Widget divider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }

  List<Widget> _buildListaRespostas() {
    List<Widget> questoes = [];

    for (var item in mapaDeQuestoes) {
      questoes.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: _buildAlternativas(
            item['questao'],
            item['resposta'],
            item['questao_ordem'],
          ),
        ),
      );
      questoes.add(divider());
    }

    return questoes;
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
        } else if (widget.provaStore.tempoExecucaoStore == null) {
          store.questoesParaRevisar.add(questao);
          store.quantidadeDeQuestoesSemRespostas++;
        }
      } else {
        if (widget.provaStore.tempoExecucaoStore == null) {
          store.questoesParaRevisar.add(questao);
        }
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
    }
  }

  _buildAlternativas(String titulo, String resposta, int questaoOrdem) {
    if (kIsMobile) {
      if (temaStore.incrementador > 20) {
        titulo = titulo.substring(0, 3);
      }
    }

    return Row(
      children: [
        Expanded(
          flex: kIsMobile ? 8 : flexQuestao,
          child: Texto(
            titulo,
            maxLines: 1,
            fontSize: 14,
          ),
        ),
        Flexible(
          flex: flexAlternativa,
          child: Center(
            child: _buildRespostaAlternativa(resposta),
          ),
        ),
        Flexible(
          flex: flexRevisao,
          child: Center(
            child: _buildRespostaRevisar(resposta, questaoOrdem),
          ),
        ),
      ],
    );
  }

  _buildRespostaAlternativa(String resposta) {
    if (resposta != "") {
      return Texto(
        resposta.replaceAll(")", ""),
        center: true,
        bold: true,
        fontSize: 14,
      );
    } else {
      return SvgPicture.asset(
        AssetsUtil.iconeQuestaoNaoRespondida,
      );
    }
  }

  _buildRespostaRevisar(String resposta, int questaoOrdem) {
    return InkWell(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      onTap: () {
        widget.provaStore.tempoCorrendo = EnumTempoStatus.CORRENDO;
        if ((widget.provaStore.tempoExecucaoStore != null && !widget.provaStore.tempoExecucaoStore!.isTempoExtendido) &&
            resposta == "") {
          store.quantidadeDeQuestoesSemRespostas = 0;
          Navigator.of(context).pop(questaoOrdem);
        } else if (resposta != "") {
          store.quantidadeDeQuestoesSemRespostas = 0;
          Navigator.of(context).pop(questaoOrdem);
        } else if (widget.provaStore.tempoExecucaoStore == null && resposta == "") {
          store.quantidadeDeQuestoesSemRespostas = 0;
          Navigator.of(context).pop(questaoOrdem);
        }
      },
      child: SvgPicture.asset(
        AssetsUtil.iconeRevisarQuestao,
      ),
    );
  }

  Widget mensagemDeQuestoesSemRespostas() {
    if (store.quantidadeDeQuestoesSemRespostas > 0) {
      String texto;

      if (store.quantidadeDeQuestoesSemRespostas > 1) {
        texto = "${store.quantidadeDeQuestoesSemRespostas} Questões sem resposta";
      } else {
        texto = "${store.quantidadeDeQuestoesSemRespostas} Questão sem resposta";
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            //
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                AssetsUtil.iconeQuestaoNaoRespondida,
              ),
            ),
            //
            Expanded(
              child: Texto(
                texto,
                color: TemaUtil.laranja03,
                fontSize: 14,
                maxLines: 2,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 40,
      );
    }
  }

  finalizarProva() async {
    bool finalizar = true;

    finalizar = await checarFinalizacaoComTempo();

    if (finalizar) {
      await widget.provaStore.finalizarProva(context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeView()),
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
