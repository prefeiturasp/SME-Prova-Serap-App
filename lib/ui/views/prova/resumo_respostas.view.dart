import 'dart:developer';

import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/utils/icone.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get_it/get_it.dart';

class ResumoRespostasView extends BaseStatefulWidget {
  const ResumoRespostasView({
    required this.provaStore,
  }) : super(title: "Resumo das respostas");
  final ProvaStore provaStore;

  @override
  _ResumoRespostasViewState createState() => _ResumoRespostasViewState();
}

class _ResumoRespostasViewState
    extends BaseStateWidget<ResumoRespostasView, ProvaViewStore> {
  List<Map<String, dynamic>> mapaDeQuestoes = [];
  List<TableRow> questoesTabela = [];

  String tratarTexto(String texto) {
    RegExp r = RegExp(r"<[^>]*>");
    String textoNovo = texto.replaceAll(r, '');
    textoNovo = textoNovo.replaceAll('\n', '');
    
    return textoNovo;
  }

  void popularMapaDeQuestoes() {
    for (Questao questao in widget.provaStore.prova.questoes) {
      for (ProvaResposta resposta in store.respostas) {
        if (questao.id == resposta.questaoId) {
          String alternativaSelecionada = "";
          questao.alternativas.forEach(
            (alternativa) {
              if (alternativa.id == resposta.alternativaId) {
                alternativaSelecionada = alternativa.numeracao;
              }
            },
          );

          String respostaNaTela = resposta.resposta ?? alternativaSelecionada;

          String questaoProva =
              tratarTexto(questao.titulo) + tratarTexto(questao.descricao);

          mapaDeQuestoes.add(
            {
              'questao': '${questao.ordem + 1} - $questaoProva',
              'resposta': respostaNaTela,
              'questao_ordem': '${questao.ordem}'
            },
          );
        }
      }
    }
    popularTabelaComQuestoes();
  }

  Widget mensagemDeQuestoesSemRespostas() {
    if (store.quantidadeDeQuestoesSemRespostas > 0) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            //
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset(
                IconeUtil.iconeQuestaoNaoRespondida,
              ),
            ),
            //
            store.quantidadeDeQuestoesSemRespostas > 1
                ? Text(
                    "${store.quantidadeDeQuestoesSemRespostas} Questões sem resposta",
                    style: TextStyle(
                      color: TemaUtil.laranja03,
                    ),
                  )
                : Text(
                    "${store.quantidadeDeQuestoesSemRespostas} Questão sem resposta",
                    style: TextStyle(
                      color: TemaUtil.laranja03,
                    ),
                  )
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 10,
      );
    }
  }

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  void initState() {
    super.initState();
    popularMapaDeQuestoes();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
    );
  }

  List<TableRow> popularTabelaComQuestoes() {
    List<TableRow> linhas = [];

    mapaDeQuestoes.forEach(
      (questao) {
        Widget resposta;

        if (questao['resposta'] != "") {
          print(1);
          resposta = Text(
            questao['resposta'].replaceAll(")", ""),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          store.setQuantidadeDeQuestoesSemRespostas();
          resposta = SvgPicture.asset(
            IconeUtil.iconeQuestaoNaoRespondida,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: HtmlWidget(
                  questao['questao'],
                  textStyle: TextStyle(fontSize: 12),
                  customStylesBuilder: (element) {
                    return {'font-size': '12px'};
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: resposta),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  onTap: () {
                    print("TOCANDO PARA REVISAR $questao['questao']");
                  },
                  child: SvgPicture.asset(
                    IconeUtil.iconeRevisarQuestao,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

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
          Text("Questão"),
          Text("Alternativa selecionada"),
          Text("Revisar"),
        ],
      ),
    );

    return questoesTabela;
  }

  @override
  Widget builder(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                'Resumo das respostas',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            //
            mensagemDeQuestoesSemRespostas(),
            //
            //
            //
            //
            //
            Table(
              columnWidths: {
                0: FractionColumnWidth(.7),
                1: FractionColumnWidth(.2),
                2: FractionColumnWidth(.1),
              },
              children: questoesTabela,
            ),
          ],
        ),
      ),
    );

    /*return DataTable(
      columnSpacing: 60,

      columns: <DataColumn>[
        DataColumn(
          label: Text("Questão"),
        ),
        DataColumn(
          label: Text("Alternativa selecionada"),
        ),
        DataColumn(
          label: Text("Revisar"),
        ),
      ],
      rows: <DataRow>[
        //
        DataRow(
          cells: <DataCell>[
            DataCell(
              Text("Questão 1 - pipipi"),
            ),
            DataCell(
              SvgPicture.asset(
                IconeUtil.iconeQuestaoNaoRespondida,
              ),
            ),
            DataCell(
              InkWell(
                child: SvgPicture.asset(
                  IconeUtil.iconeRevisarQuestao,
                ),
              ),
            ),
          ],
        ),
        //
        DataRow(
          cells: <DataCell>[
            DataCell(
              Text("Questão 1 - pipipi"),
            ),
            DataCell(
              SvgPicture.asset(
                IconeUtil.iconeQuestaoNaoRespondida,
              ),
            ),
            DataCell(
              InkWell(
                child: SvgPicture.asset(
                  IconeUtil.iconeRevisarQuestao,
                ),
              ),
            ),
          ],
        ),
        //
        DataRow(
          cells: <DataCell>[
            DataCell(
              Text("Questão 1 - pipipi"),
            ),
            DataCell(
              SvgPicture.asset(
                IconeUtil.iconeQuestaoNaoRespondida,
              ),
            ),
            DataCell(
              InkWell(
                child: SvgPicture.asset(
                  IconeUtil.iconeRevisarQuestao,
                ),
              ),
            ),
          ],
        ),
      ],
    );*/
  }
}
