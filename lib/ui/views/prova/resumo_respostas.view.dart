import 'dart:developer';

import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
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
  List<TableRow> questoesTabela = [];

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
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      subtitulo: widget.provaStore.prova.descricao,
    );
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
            Text(
              'Resumo das respostas',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            //
            Observer(builder: (context) {
              return mensagemDeQuestoesSemRespostas();
            }),
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
            SizedBox(height: 32),
            Center(
              child: BotaoDefaultWidget(
                textoBotao: 'FINALIZAR E ENVIAR',
                largura: 392,
                onPressed: () async {
                  await widget.provaStore.finalizarProva();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SplashScreenView()),
                    (_) => false,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

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
    for (Questao questao in widget.provaStore.prova.questoes) {
      ProvaResposta? resposta = widget.provaStore.respostas.obterResposta(questao.id);

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

        if (alternativaSelecionada.isNotEmpty) {
          respostaNaTela = alternativaSelecionada;
        } else if (resposta!.resposta!.isNotEmpty) {
          respostaNaTela = "OK";
        } else {
          store.quantidadeDeQuestoesSemRespostas++;
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
                      fontSize: 14,
                    ),
                  )
                : Text(
                    "${store.quantidadeDeQuestoesSemRespostas} Questão sem resposta",
                    style: TextStyle(
                      color: TemaUtil.laranja03,
                      fontSize: 14,
                    ),
                  )
          ],
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
          Text(
            "Questão",
            style: TextStyle(fontSize: 14, color: TemaUtil.appBar),
          ),
          Text(
            "Alternativa selecionada",
            style: TextStyle(fontSize: 14, color: TemaUtil.appBar),
          ),
          Text(
            "Revisar",
            style: TextStyle(fontSize: 14, color: TemaUtil.appBar),
          ),
        ],
      ),
    );

    return questoesTabela;
  }
}
