import 'dart:developer';

import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class ResumoRespostasView extends BaseStatefulWidget {
  const ResumoRespostasView({
    required this.provaStore,
  }) : super(title: "Resumo das respostas");
  final ProvaStore provaStore;

  @override
  _ResumoRespostasViewState createState() => _ResumoRespostasViewState();
}

class _ResumoRespostasViewState extends BaseStateWidget<ResumoRespostasView, ProvaViewStore> {
  List<Map<String, dynamic>> mapaDeQuestoes = [];
  List<TableRow> questoesTabela = [];

  String tratarTexto(String texto) {
    RegExp r = RegExp(r"<[^>]*>");
    String textoNovo = texto.replaceAll(r, '');
    textoNovo = textoNovo.replaceAll('\n', ' ').replaceAll(':', ': ');
    if (textoNovo.length >= 50) {
      textoNovo = textoNovo.substring(0, 50) + '...';
    }
    return textoNovo;
  }

  void popularMapaDeQuestoes() {
    for (Questao questao in store.questoes) {
      ProvaResposta? resposta = store.obterResposta(questao.id);

      String alternativaSelecionada = "";
      String respostaNaTela = "";
      String questaoProva = tratarTexto(tratarTexto(questao.titulo) + tratarTexto(questao.descricao));
      String ordemQuestaoTratada = questao.ordem < 10 ? '0${questao.ordem + 1}' : '${questao.ordem + 1}';

      if (questao.id == resposta?.questaoId) {
        for (var alternativa in questao.alternativas) {
          if (alternativa.id == resposta!.alternativaId) {
            alternativaSelecionada = alternativa.numeracao;
          }
        }

        if (resposta!.resposta != null) {
          respostaNaTela = "OK";
        } else {
          respostaNaTela = alternativaSelecionada;
        }

        mapaDeQuestoes.add(
          {
            'questao': '$ordemQuestaoTratada - $questaoProva',
            'resposta': respostaNaTela,
            'questao_ordem': questao.ordem
          },
        );
      } else {
        store.quantidadeDeQuestoesSemRespostas++;
        mapaDeQuestoes.add(
          {
            'questao': '$ordemQuestaoTratada - $questaoProva',
            'resposta': respostaNaTela,
            'questao_ordem': questao.ordem
          },
        );
      }

      mapaDeQuestoes.sort(
        (questao1, questao2) {
          return questao1['questao_ordem'].compareTo(questao2['questao_ordem']);
        },
      );

      popularTabelaComQuestoes();
    }
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
                AssetsUtil.iconeQuestaoNaoRespondida,
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
    //store.dispose();
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

    for (var questao in mapaDeQuestoes) {
      Widget resposta;

      if (questao['resposta'] != "") {
        resposta = Center(
          child: Text(
            questao['resposta'].replaceAll(")", ""),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                questao['questao'],
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
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
                  store.quantidadeDeQuestoesSemRespostas = 0;
                  Navigator.of(context).pop(questao['questao_ordem']);
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
  }
}
