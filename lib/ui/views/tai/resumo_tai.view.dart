import 'package:appserap/main.route.gr.dart';
import 'package:appserap/stores/resumo_tai_view.store.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../main.ioc.dart';
import '../../../main.route.dart';

@RoutePage()
class ResumoTaiView extends BaseStatefulWidget {
  final int provaId;

  const ResumoTaiView({
    super.key,
    required this.provaId,
  });

  @override
  State<ResumoTaiView> createState() => _ResumoTaiViewState();
}

class _ResumoTaiViewState extends BaseStateWidget<ResumoTaiView, ResumoTaiViewStore> {
  int flexQuestao = 18;
  int flexAlternativa = 4;

  @override
  double get defaultPadding => 0;

  @override
  bool get willPop => false;

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  AppBarWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      subtitulo: store.provaStore?.prova.descricao ?? "",
      mostrarBotaoVoltar: false,
    );
  }

  @override
  void initState() {
    super.initState();
    store.carregarResumo(widget.provaId);
  }

  @override
  Widget builder(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Observer(builder: (_) {
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

        return _buildResumo();
      }),
    );
  }

  Widget _buildResumo() {
    return Column(
      children: [
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
                            Texto(
                              'Resumo das respostas',
                              textAlign: TextAlign.start,
                              color: TemaUtil.preto,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
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
                                textoBotao: 'FECHAR',
                                largura: 392,
                                desabilitado: store.botaoFinalizarOcupado,
                                onPressed: () async {
                                  try {
                                    store.botaoFinalizarOcupado = true;

                                    await WakelockPlus.disable();

                                    sl<AppRouter>().pushAndPopUntil(HomeViewRoute(), predicate: (_) => false);
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
    );
  }

  _buildCabecalho() {
    List<Widget> rows = [];

    if (kIsMobile) {
      if (temaStore.incrementador > 16) {
        flexQuestao = 5;
      } else {
        flexQuestao = 8;
      }
    } else {
      if (temaStore.incrementador > 20) {
        flexQuestao = 14;
        flexAlternativa = 7;
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

    for (var item in store.resumo!) {
      questoes.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: _buildAlternativas(
            item.ordemQuestao,
            item.descricaoQuestao,
            item.alternativaAluno,
          ),
        ),
      );
      questoes.add(divider());
    }

    return questoes;
  }

  _buildAlternativas(int ordem, String descricao, String resposta) {
    ordem = ordem == 0 ? 1 : ordem;

    String ordemQuestaoTratada = ordem < 10 ? '0$ordem' : '$ordem ';

    String titulo = "$ordemQuestaoTratada - ${tratarTexto(descricao)}";

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
      ],
    );
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
}
