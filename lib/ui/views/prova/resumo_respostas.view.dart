import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tempo_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/models/prova_caderno.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/models/resposta_prova.model.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/prova_tempo_exeucao.store.dart';
import 'package:appserap/stores/questao_revisao.store.dart';
import 'package:appserap/ui/views/prova/widgets/tempo_execucao.widget.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/status_sincronizacao/status_sincronizacao.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class ResumoRespostasView extends BaseStatefulWidget {
  final int idProva;

  ResumoRespostasView({
    Key? key,
    required this.idProva,
  }) : super(key: key, title: "Resumo das respostas");

  @override
  _ResumoRespostasViewState createState() => _ResumoRespostasViewState();
}

class _ResumoRespostasViewState extends BaseStateWidget<ResumoRespostasView, QuestaoRevisaoStore> with Loggable {
  late final ProvaStore provaStore;

  int flexQuestao = 18;
  int flexAlternativa = 4;
  int flexRevisao = 3;

  @override
  void initState() {
    super.initState();
    var provas = ServiceLocator.get<HomeStore>().provas;

    if (provas.isEmpty) {
      ServiceLocator.get<AppRouter>().router.go("/");
    }

    provaStore = provas.filter((prova) => prova.key == widget.idProva).first.value;
    popularMapaDeQuestoes();
  }

  @override
  void dispose() {
    provaStore.setRespondendoProva(false);
    super.dispose();
  }

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  double get defaultPadding => 0;

  @override
  bool get willPop => false;

  @override
  AppBarWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      subtitulo: provaStore.prova.descricao,
      mostrarBotaoVoltar: false,
    );
  }

  @override
  Widget builder(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        children: [
          TempoExecucaoWidget(provaStore: provaStore),
          StatusSincronizacao(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: getPadding(),
                child: Observer(
                  builder: (_) {
                    return Column(
                      children: [
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
                                  desabilitado: store.botaoFinalizarOcupado,
                                  onPressed: () async {
                                    try {
                                      store.botaoFinalizarOcupado = true;
                                      await finalizarProva();
                                    } catch (e, stack) {
                                      await recordError(e, stack);
                                    } finally {
                                      store.botaoFinalizarOcupado = false;
                                    }
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
          ),
        ],
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

    for (var item in store.mapaDeQuestoes) {
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

  String tratarTexto(String? texto) {
    if (texto == null) {
      return '';
    }

    RegExp r = RegExp(r"<[^>]*>");
    String textoNovo = texto.replaceAll(r, '');
    textoNovo = textoNovo.replaceAll('\n', ' ').replaceAll(':', ': ');
    return textoNovo;
  }

  Future<void> popularMapaDeQuestoes() async {
    store.quantidadeDeQuestoesSemRespostas = 0;
    store.questoesParaRevisar.clear();
    store.mapaDeQuestoes.clear();

    var db = ServiceLocator.get<AppDatabase>();

    var questoes = await db.questaoDao.obterPorProvaECaderno(widget.idProva, provaStore.caderno);

    for (Questao questao in questoes) {
      int questaoId = await db.provaCadernoDao.obterQuestaoIdPorProvaECadernoEQuestao(
        widget.idProva,
        provaStore.caderno,
        questao.questaoLegadoId,
      );

      RespostaProva? resposta = provaStore.respostas.respostasLocal[questaoId];
      ProvaCaderno provaCaderno = await db.provaCadernoDao.findByQuestaoId(
        questaoId,
        widget.idProva,
        provaStore.caderno,
      );

      String alternativaSelecionada = "";
      String respostaNaTela = "";
      String questaoProva = tratarTexto(questao.titulo) + tratarTexto(questao.descricao);

      String ordemQuestaoTratada = provaCaderno.ordem < 10 ? '0${provaCaderno.ordem + 1}' : '${provaCaderno.ordem + 1}';

      if (questaoId == resposta?.questaoId) {
        var alternativas = await db.alternativaDao.obterPorQuestaoLegadoId(questao.questaoLegadoId);

        for (var alternativa in alternativas) {
          if (alternativa.ordem == resposta!.ordem) {
            alternativaSelecionada = alternativa.numeracao;
          }
        }

        bool podeAdicionarRespostaVazia =
            (resposta!.resposta == null || resposta.resposta!.isEmpty || alternativaSelecionada.isEmpty) &&
                (provaStore.tempoExecucaoStore != null && !provaStore.tempoExecucaoStore!.isTempoExtendido);

        bool removeQuestaoQueNaoPodeRevisar =
            (resposta.resposta == null || resposta.resposta!.isEmpty || alternativaSelecionada.isEmpty) &&
                (provaStore.tempoExecucaoStore != null && !provaStore.tempoExecucaoStore!.isTempoExtendido);

        if (alternativaSelecionada.isNotEmpty) {
          respostaNaTela = alternativaSelecionada;
          store.questoesParaRevisar.putIfAbsent(provaCaderno.ordem, () => questao);
        } else if (resposta.resposta != null && resposta.resposta!.isNotEmpty) {
          respostaNaTela = "OK";
          store.questoesParaRevisar.putIfAbsent(provaCaderno.ordem, () => questao);
        } else if (podeAdicionarRespostaVazia) {
          store.questoesParaRevisar.putIfAbsent(provaCaderno.ordem, () => questao);
          store.quantidadeDeQuestoesSemRespostas++;
        } else if (removeQuestaoQueNaoPodeRevisar) {
          store.questoesParaRevisar.remove(questao);
          store.quantidadeDeQuestoesSemRespostas++;
        } else if (provaStore.tempoExecucaoStore == null) {
          store.questoesParaRevisar.putIfAbsent(provaCaderno.ordem, () => questao);
          store.quantidadeDeQuestoesSemRespostas++;
        } else {
          store.quantidadeDeQuestoesSemRespostas++;
        }
      } else {
        if (provaStore.tempoExecucaoStore == null) {
          store.questoesParaRevisar.putIfAbsent(provaCaderno.ordem, () => questao);
        }
        store.quantidadeDeQuestoesSemRespostas++;
      }

      store.mapaDeQuestoes.add(
        {
          'questao': '$ordemQuestaoTratada - $questaoProva',
          'resposta': respostaNaTela,
          'questao_ordem': provaCaderno.ordem,
        },
      );

      store.mapaDeQuestoes.sort(
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
        provaStore.tempoCorrendo = EnumTempoStatus.CORRENDO;
        store.posicaoQuestaoSendoRevisada = questaoOrdem;

        if ((provaStore.tempoExecucaoStore != null && !provaStore.tempoExecucaoStore!.isTempoExtendido) &&
            resposta == "") {
          store.quantidadeDeQuestoesSemRespostas = 0;
          context.go("/prova/${provaStore.id}/revisao/$questaoOrdem");
        } else if (resposta != "") {
          store.quantidadeDeQuestoesSemRespostas = 0;
          context.go("/prova/${provaStore.id}/revisao/$questaoOrdem");
        } else if (provaStore.tempoExecucaoStore == null && resposta == "") {
          store.quantidadeDeQuestoesSemRespostas = 0;
          context.go("/prova/${provaStore.id}/revisao/$questaoOrdem");
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
      bool provaFinalizada = await provaStore.finalizarProva();
      if (provaFinalizada) {
        ServiceLocator.get<AppRouter>().router.go("/");
      }
    }
  }

  Future<bool> checarFinalizacaoComTempo() async {
    ProvaTempoExecucaoStore? tempoExecucaoStore = provaStore.tempoExecucaoStore;
    if (tempoExecucaoStore != null) {
      bool possuiTempoNormalRestante =
          tempoExecucaoStore.isTempoNormalEmExecucao && tempoExecucaoStore.possuiTempoRestante;

      if (possuiTempoNormalRestante) {
        return (await mostrarDialogAindaPossuiTempo(
          context,
          provaStore.tempoExecucaoStore!.tempoRestante,
        ))!;
      }
    }

    return true;
  }
}
