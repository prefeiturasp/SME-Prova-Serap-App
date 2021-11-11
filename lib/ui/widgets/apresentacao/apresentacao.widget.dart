import 'package:appserap/stores/apresentacao.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/ui/views/prova/prova.view.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao.model.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class ApresentacaoWidget extends StatelessWidget {
  final BaseStatefulWidget? avancarParaPagina;
  final List<ApresentacaoModelWidget> listaDePaginas;
  String textoBotaoAvancar;
  String textoBotaoPular;
  bool regraMostrarTodosOsBotoesAoIniciar;
  bool regraMostrarApenasBotaoPoximo;
  bool pularSeNaoTiverConexao;
  String flagExecutarFuncao;
  ProvaStore? provaStore;

  ApresentacaoWidget({
    this.avancarParaPagina,
    required this.listaDePaginas,
    required this.textoBotaoAvancar,
    required this.textoBotaoPular,
    required this.regraMostrarTodosOsBotoesAoIniciar,
    required this.regraMostrarApenasBotaoPoximo,
    this.pularSeNaoTiverConexao = true,
    this.flagExecutarFuncao = "",
    this.provaStore,
  });

  final store = GetIt.I.get<ApresentacaoStore>();
  final PageController _controllerDicas = PageController(initialPage: 0);

  void _irParaProximaPagina(context) {
    store.pagina = 0;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) {
        if (flagExecutarFuncao == "prova") {
          provaStore!.iniciarProva();
          return ProvaView(provaStore: provaStore!);
        }
        return avancarParaPagina!;
      }),
    );
  }

  onAfterBuild(BuildContext context) {
    //if (!_principalStore.temConexao) {
    if (pularSeNaoTiverConexao) {
      _irParaProximaPagina(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => onAfterBuild(context));

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .65,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _controllerDicas,
            itemCount: listaDePaginas.length,
            onPageChanged: (int posicao) {
              store.pagina = posicao;
            },
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 20),
                child: _buildPaginaOrientacaoAdaptativa(
                  context,
                  listaDePaginas[index].ehHTML,
                  listaDePaginas[index].titulo!,
                  listaDePaginas[index].descricao!,
                  listaDePaginas[index].imagem!,
                  listaDePaginas[index].corpoPersonalizado!,
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
  Widget _buildPaginaOrientacaoAdaptativa(
    BuildContext context,
    bool ehHTML,
    String titulo,
    String descricao,
    Widget imagem,
    Widget corpoHTML,
  ) {
    if (kIsMobile) {
      if (ehHTML) {
        return ListView(
          children: [corpoHTML],
        );
      }
      return ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 18),
            height: 150,
            child: imagem,
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
            child: Texto(
              descricao,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              center: true,
              maxLines: 10,
            ),
          ),
        ],
      );
    }

    return _builderPaginaOrientacao(
      context,
      ehHTML,
      titulo,
      descricao,
      imagem,
      corpoHTML,
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
  _builderPaginaOrientacao(
    BuildContext context,
    bool ehHTML,
    String titulo,
    String descricao,
    Widget imagem,
    Widget corpoHTML,
  ) {
    if (ehHTML) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        child: ListView(
          children: [
            corpoHTML,
          ],
        ),
      );
    }
    return ListView(
      children: [
        imagem,

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
          child: Texto(
            descricao,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            center: true,
            maxLines: 10,
          ),
        ),
      ],
    );
  }

  //
  Widget _buildPaginacao() {
    return ListView.builder(
      itemCount: listaDePaginas.length,
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
    bool ehUltimaDica = store.pagina == listaDePaginas.length - 1;

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
