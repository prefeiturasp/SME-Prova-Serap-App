import 'package:appserap/dtos/prova_resultado_resumo_questao.response.dto.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/main.route.gr.dart';
import 'package:appserap/stores/prova_resultado_resumo_view.store.dart';
import 'package:appserap/ui/widgets/adaptative/adaptative.icon.button.widget.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/string.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

@RoutePage()
class ProvaResultadoResumoView extends BaseStatefulWidget {
  final int provaId;
  final String caderno;

  const ProvaResultadoResumoView({
    super.key,
    @PathParam('idProva') required this.provaId,
    @PathParam('caderno') required this.caderno,
  });

  @override
  State<ProvaResultadoResumoView> createState() => _ProvaResultadoResumoViewState();
}

class _ProvaResultadoResumoViewState extends BaseStateWidget<ProvaResultadoResumoView, ProvaResultadoResumoViewStore> {
  final ScrollController _controller = ScrollController();

  var espacamentoTabela = [2, 6, 5, 3, 3];

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  AppBarWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      leading: _buildLeading(),
    );
  }

  Widget? _buildLeading() {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        context.router.push(HomeViewRoute());
      },
    );
  }

  @override
  void initState() {
    super.initState();
    store.carregarResumo(provaId: widget.provaId, caderno: widget.caderno);
  }

  @override
  Widget builder(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      controller: _controller,
      child: SingleChildScrollView(
        controller: _controller,
        child: Observer(builder: (_) {
          if (store.carregando) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: getPadding(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Texto(
                          'Resultado da prova',
                          textAlign: TextAlign.start,
                          color: TemaUtil.preto,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Texto(
                              "Total de questões: ${store.totalQuestoes}",
                              color: TemaUtil.azul02,
                              fontSize: 14,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            //
                            Expanded(
                              child: Texto(
                                "Total de acertos: ${store.response!.resumos.where((element) => element.correta).toList().length}",
                                color: TemaUtil.azul02,
                                fontSize: 14,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildProficiencia(),
                      //
                      SizedBox(height: 20),
                      Observer(builder: (_) {
                        return Column(
                          children: [
                            _buildCabecalho(),
                            _divider(),
                            ..._buildListaRespostas(),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  _buildCabecalho() {
    return Row(
      children: [
        Expanded(
          flex: espacamentoTabela[0],
          child: Texto(
            "Ordem",
            fontSize: 14,
            color: TemaUtil.appBar,
          ),
        ),
        Expanded(
          flex: espacamentoTabela[1],
          child: Texto(
            "Questão",
            fontSize: 14,
            color: TemaUtil.appBar,
          ),
        ),
        Expanded(
          flex: espacamentoTabela[2],
          child: Center(
            child: Texto(
              "Resposta Correta",
              fontSize: 14,
              color: TemaUtil.appBar,
            ),
          ),
        ),
        Expanded(
          flex: espacamentoTabela[3],
          child: Center(
            child: Texto(
              "Resposta",
              fontSize: 14,
              color: TemaUtil.appBar,
            ),
          ),
        ),
        Expanded(
          flex: espacamentoTabela[4],
          child: Center(
            child: Texto(
              "Visualizar",
              fontSize: 14,
              color: TemaUtil.appBar,
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildListaRespostas() {
    var resumo = store.response!.resumos;
    List<Widget> questoes = [];

    for (var item in resumo) {
      questoes.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: _buildResumo(item),
        ),
      );
      questoes.add(_divider());
    }

    return questoes;
  }

  Widget _buildResumo(ProvaResultadoResumoQuestaoResponseDto questaoResumo) {
    String ordemQuestaoTratada =
        questaoResumo.ordemQuestao < 9 ? '0${questaoResumo.ordemQuestao + 1}' : '${questaoResumo.ordemQuestao + 1}';

    return Row(
      children: [
        Expanded(
          flex: espacamentoTabela[0],
          child: Texto(
            ordemQuestaoTratada,
            maxLines: 1,
            fontSize: 14,
          ),
        ),
        Expanded(
          flex: espacamentoTabela[1],
          child: Texto(
            tratarTexto(questaoResumo.descricaoQuestao ?? ""),
            maxLines: 1,
            fontSize: 14,
          ),
        ),
        Expanded(
          flex: espacamentoTabela[2],
          child: Center(
            child: Texto(
              questaoResumo.alternativaCorreta,
              maxLines: 1,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: espacamentoTabela[3],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._buildResposta(questaoResumo),
            ],
          ),
        ),
        Expanded(
          flex: espacamentoTabela[4],
          child: Center(
            child: _buildVisualizar(questaoResumo.idQuestaoLegado, questaoResumo.ordemQuestao),
          ),
        )
      ],
    );
  }

  List<Widget> _buildResposta(ProvaResultadoResumoQuestaoResponseDto questaoResumo) {
    if (questaoResumo.tipoQuestao == EnumTipoQuestao.MULTIPLA_ESCOLHA) {
      return [
        Texto(
          questaoResumo.alternativaAluno ?? ' - ',
          maxLines: 1,
          fontSize: 14,
        ),
        _buildResultadoAlternativaIcone(questaoResumo.correta),
      ];
    } else {
      return [_buildResultadoConstruidoIcone(questaoResumo.respostaConstruidaRespondida)];
    }
  }

  _buildResultadoAlternativaIcone(bool acerto) {
    if (acerto) {
      return Icon(
        Icons.check,
        color: TemaUtil.verde01,
      );
    }

    return Icon(
      Icons.close,
      color: TemaUtil.vermelhoErro,
    );
  }

  _buildResultadoConstruidoIcone(bool respoindido) {
    if (respoindido) {
      return Icon(
        Icons.edit_note,
        color: TemaUtil.verde01,
      );
    }

    return Icon(
      Icons.edit_note,
      color: TemaUtil.vermelhoErro,
    );
  }

  _buildVisualizar(int idQuestaoLegado, int questaoOrdem) {
    return InkWell(
      enableFeedback: !store.prova!.apresentarResultadosPorItem,
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      onTap: () {
        if (store.prova!.apresentarResultadosPorItem) {
          context.router.push(
            QuestaoResultadoDetalhesViewRoute(
              key: ValueKey("${widget.provaId}-$questaoOrdem"),
              provaId: widget.provaId,
              caderno: widget.caderno,
              ordem: questaoOrdem,
            ),
          );
        }
      },
      child: AdaptativeSVGIcon(
        AssetsUtil.iconeRevisarQuestao,
        icon: Container(
          color: Color(0xFFE5EEEB),
          child: Icon(
            Icons.edit_note,
            color: Color(0xff10A1C1),
          ),
        ),
        colorFilter: !store.prova!.apresentarResultadosPorItem
            ? ColorFilter.mode(
                TemaUtil.cinza,
                BlendMode.srcIn,
              )
            : null,
      ),
    );
  }

  Widget _buildProficiencia() {
    if (store.prova!.provaComProficiencia) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            //
            Expanded(
              child: Texto(
                "Proficiência: ${store.response?.proficiencia.toStringAsFixed(2) ?? 0}",
                color: TemaUtil.azul02,
                fontSize: 14,
                maxLines: 2,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox.shrink();
  }
}
