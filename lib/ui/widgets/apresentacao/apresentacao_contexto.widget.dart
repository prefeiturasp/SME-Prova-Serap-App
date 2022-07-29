import 'dart:convert';

import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:appserap/stores/apresentacao.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ApresentacaoContextoWidget extends StatelessWidget {
  final BaseStatefulWidget? avancarParaPagina;
  final List<ContextoProva> listaDePaginasContexto;
  final String textoBotaoAvancar;
  final String textoBotaoPular;
  final bool regraMostrarTodosOsBotoesAoIniciar;
  final bool regraMostrarApenasBotaoPoximo;
  final ProvaStore? provaStore;

  ApresentacaoContextoWidget({
    this.avancarParaPagina,
    required this.listaDePaginasContexto,
    required this.textoBotaoAvancar,
    required this.textoBotaoPular,
    required this.regraMostrarTodosOsBotoesAoIniciar,
    required this.regraMostrarApenasBotaoPoximo,
    this.provaStore,
  });

  final store = GetIt.I.get<ApresentacaoStore>();
  final PageController _controllerDicas = PageController(initialPage: 0);

  void _irParaProximaPagina(BuildContext context) {
    store.pagina = 0;
    context.go("/prova/${provaStore!.id}/");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _controllerDicas,
            itemCount: listaDePaginasContexto.length,
            onPageChanged: (int posicao) {
              store.pagina = posicao;
            },
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 20),
                child: _buildPaginaContextoAdaptativa(
                  context,
                  listaDePaginasContexto[index].titulo!,
                  listaDePaginasContexto[index].texto!,
                  listaDePaginasContexto[index].imagemBase64!,
                  listaDePaginasContexto[index].posicionamento!.index,
                ),
              );
            },
          ),
        ),
        //
        SizedBox(
          height: MediaQuery.of(context).size.height * .012,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: _buildPaginacao(),
          ),
        ),
        //
        _buildBotaoNavegacaoAdaptativo(),
        //
      ],
    );
  }

  //
  Widget _buildPaginaContextoAdaptativa(
    BuildContext context,
    String titulo,
    String texto,
    String imagemBase64,
    int posicionamento,
  ) {
    if (kIsMobile) {
      return ListView(
        children: [
          _builderImagemComPosicionamento(
            posicionamento,
            imagemBase64,
            context,
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 24,
              bottom: 16,
              left: 32,
              right: 32,
            ),
            child: Texto(
              titulo,
              fontSize: 18,
              bold: true,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              maxLines: 3,
              center: true,
            ),
          ),
          //
          Container(
            padding: const EdgeInsets.only(
              left: 32,
              right: 32,
              bottom: 32,
            ),
            child: Html(
              data: texto,
              style: {
                '*': Style.fromTextStyle(
                  TextStyle(
                    fontFamily: ServiceLocator.get<TemaStore>().fonteDoTexto.nomeFonte,
                    fontSize: ServiceLocator.get<TemaStore>().size(16),
                  ),
                )
              },
            ),
          ),
        ],
      );
    }

    return _builderPaginaContexto(
      context,
      titulo,
      texto,
      imagemBase64,
      posicionamento,
    );
  }

  //

  Widget _buildBotaoNavegacaoAdaptativo() {
    if (kIsMobile) {
      return Observer(
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 14,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .18,
              child: _buildBotoesNavegacao(context),
            ),
          );
        },
      );
    }

    return Observer(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 64,
            right: 64,
            top: 16,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .18,
            child: _buildBotoesNavegacao(context),
          ),
        );
      },
    );
  }

  //

  Widget _builderImagemComPosicionamento(int posicionamento, String imagemBase64, BuildContext context) {
    Alignment posicao = Alignment.center;

    if (posicionamento == PosicionamentoImagemEnum.DIREITA.index) {
      posicao = Alignment.centerRight;
    } else if (posicionamento == PosicionamentoImagemEnum.ESQUERDA.index) {
      posicao = Alignment.centerLeft;
    }

    if (kIsMobile) {
      return Container(
        child: Image.memory(
          base64Decode(imagemBase64),
          alignment: posicao,
          width: 150,
        ),
        alignment: posicao,
      );
    }

    return Container(
      child: Image.memory(base64Decode(imagemBase64), alignment: posicao),
      width: double.infinity,
      alignment: posicao,
    );
  }

  //
  _builderPaginaContexto(
    BuildContext context,
    String titulo,
    String texto,
    String imagemBase64,
    int posicionamento,
  ) {
    if (posicionamento == PosicionamentoImagemEnum.DIREITA.index) {
    } else if (posicionamento == PosicionamentoImagemEnum.ESQUERDA.index) {}

    return ListView(
      children: [
        _builderImagemComPosicionamento(posicionamento, imagemBase64, context),

        Padding(
          padding: const EdgeInsets.only(
            top: 38,
            bottom: 16,
          ),
          child: Texto(
            titulo,
            fontSize: 24,
            bold: true,
            center: true,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        //
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64),
          child: Html(
            data: texto,
            style: {
              '*': Style.fromTextStyle(
                TextStyle(
                  fontFamily: ServiceLocator.get<TemaStore>().fonteDoTexto.nomeFonte,
                  fontSize: ServiceLocator.get<TemaStore>().size(16),
                ),
              )
            },
          ),
        ),
      ],
    );
  }

  //
  Widget _buildPaginacao() {
    return ListView.builder(
      itemCount: listaDePaginasContexto.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                store.pagina = index;
                _controllerDicas.animateToPage(
                  index,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 200),
                );
              },
              child: Observer(
                builder: (_) {
                  return store.pagina == index
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 24,
                          height: 12,
                          decoration: BoxDecoration(
                            color: TemaUtil.azulScroll,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: TemaUtil.pretoSemFoco2,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                },
              ),
            )
          ],
        );
      },
    );
  }

  //

  Widget _buildBotoesNavegacao(BuildContext context) {
    bool ehUltimaDica = store.pagina == listaDePaginasContexto.length - 1;

    if (regraMostrarTodosOsBotoesAoIniciar && !ehUltimaDica) {
      // SE TIVER LOGIN
      return Column(
        children: [
          BotaoDefaultWidget(
            largura: 400,
            textoBotao: textoBotaoAvancar,
            onPressed: () {
              _controllerDicas.animateToPage(
                store.pagina + 1,
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 200),
              );
              store.pagina++;
            },
          ),
          BotaoSecundarioWidget(
            largura: 400,
            textoBotao: textoBotaoPular,
            corDoTexto: TemaUtil.laranja01,
            onPressed: () {
              _irParaProximaPagina(context);
            },
          ),
        ],
      );
    } else if (regraMostrarApenasBotaoPoximo && !ehUltimaDica) {
      // ULTIMO LOGIN FOR NULL
      return Column(
        children: [
          BotaoDefaultWidget(
            largura: 400,
            textoBotao: textoBotaoAvancar,
            onPressed: () {
              _controllerDicas.animateToPage(
                store.pagina + 1,
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 200),
              );
              store.pagina++;
            },
          ),
        ],
      );
    } else if (ehUltimaDica) {
      // SEM LOGIN
      return Column(
        children: [
          BotaoDefaultWidget(
            largura: 400,
            textoBotao: textoBotaoPular,
            onPressed: () {
              _irParaProximaPagina(context);
            },
          ),
        ],
      );
    }

    return SizedBox();
  }
}
