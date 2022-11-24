import 'package:appserap/dtos/prova_resultado_resumo.response.dto.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/stores/prova_resultado_resumo_view.store.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/string.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProvaResultadoResumoView extends BaseStatefulWidget {
  final int provaId;
  final String caderno;

  const ProvaResultadoResumoView({
    super.key,
    required this.provaId,
    required this.caderno,
  });

  @override
  State<ProvaResultadoResumoView> createState() => _ProvaResultadoResumoViewState();
}

class _ProvaResultadoResumoViewState extends BaseStateWidget<ProvaResultadoResumoView, ProvaResultadoResumoViewStore> {
  var espacamentoTabela = [2, 8, 3, 3, 2];

  @override
  void initState() {
    super.initState();
    store.carregarResumo(provaId: widget.provaId, caderno: widget.caderno);
  }

  @override
  Widget builder(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
                      'Resumo da prova',
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
                          "Total de questões: ${store.resumo.length}",
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
                            "Total de acertos: ${store.resumo.where((element) => element.alternativaCorreta).toList().length}",
                            color: TemaUtil.azul02,
                            fontSize: 14,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                  SizedBox(height: 20),
                  Observer(builder: (_) {
                    if (store.carregando) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

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
              "Resposta",
              fontSize: 14,
              color: TemaUtil.appBar,
            ),
          ),
        ),
        Visibility(
          visible: store.prova!.provaComProficiencia,
          child: Expanded(
            flex: espacamentoTabela[3],
            child: Center(
              child: Texto(
                "Proficiencia",
                fontSize: 14,
                color: TemaUtil.appBar,
              ),
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
    var resumo = store.resumo;
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

  Widget _buildResumo(ProvaResultadoResumoResponseDto questaoResumo) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._buildResposta(questaoResumo),
            ],
          ),
        ),
        Visibility(
          visible: store.prova!.provaComProficiencia,
          child: Expanded(
            flex: espacamentoTabela[3],
            child: Center(
              child: Texto(
                questaoResumo.proficiencia?.toStringAsFixed(2) ?? "0",
                maxLines: 1,
                fontSize: 14,
              ),
            ),
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

  List<Widget> _buildResposta(ProvaResultadoResumoResponseDto questaoResumo) {
    if (questaoResumo.tipoQuestao == EnumTipoQuestao.MULTIPLA_ESCOLHA) {
      return [
        Texto(
          questaoResumo.alternativaAluno ?? ' - ',
          maxLines: 1,
          fontSize: 14,
        ),
        _buildResultadoAlternativaIcone(questaoResumo.alternativaCorreta),
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
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      onTap: () {
        context.push(
          "/prova/resposta/${widget.provaId}/${widget.caderno}/$questaoOrdem/detalhes",
          extra: store.resumo.toList(),
        );
      },
      child: SvgPicture.asset(
        AssetsUtil.iconeRevisarQuestao,
      ),
    );
  }
}
