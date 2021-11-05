import 'package:appserap/enums/tipo_dispositivo.enum.dart';
import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class OrientacaoInicialView extends StatefulWidget {
  const OrientacaoInicialView({Key? key}) : super(key: key);

  @override
  _OrientacaoInicialViewState createState() => _OrientacaoInicialViewState();
}

class _OrientacaoInicialViewState extends State<OrientacaoInicialView> {
  final PageController _controllerDicas = PageController(initialPage: 0);

  final store = GetIt.I.get<OrientacaoInicialStore>();
  final _principalStore = GetIt.I.get<PrincipalStore>();

  void _irParaTelaInicial(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeView()),
    );
  }

  onAfterBuild(BuildContext context) {
    if (!_principalStore.temConexao) {
      _irParaTelaInicial(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => onAfterBuild(context));

    return SafeArea(
      child: Scaffold(
        backgroundColor: TemaUtil.corDeFundo,
        body: _builderCorpoOrientacoes(),
        persistentFooterButtons: _buildPersistentFooterButtons(),
      ),
    );
  }

  List<Widget>? _buildPersistentFooterButtons() {
    return [
      Center(
        child: Observer(
          builder: (_) {
            var cor = TemaUtil.preto;

            if (!_principalStore.temConexao) {
              cor = TemaUtil.vermelhoErro;
            }

            return Texto(
              _principalStore.versao,
              color: cor,
              fontSize: 14,
            );
          },
        ),
      )
    ];
  }

  _builderCorpoOrientacoes() {
    return Observer(
      builder: (_) {
        return PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: _controllerDicas,
          itemCount: store.listaPaginasOrientacoes.length,
          onPageChanged: (int posicao) {
            store.pagina = posicao;
          },
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .65,
                  child: _buildPaginaOrientacaoAdaptativa(
                    store.listaPaginasOrientacoes[index].ehHTML,
                    store.listaPaginasOrientacoes[index].titulo!,
                    store.listaPaginasOrientacoes[index].descricao!,
                    store.listaPaginasOrientacoes[index].imagem!,
                    store.listaPaginasOrientacoes[index].corpoPersonalizado!,
                  ),
                ),
                //
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                  child: _buildPaginacao(),
                ),
                //
                _buildBotaoNavegacaoAdaptativo(),
                //
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPaginaOrientacaoAdaptativa(
    bool ehHTML,
    String titulo,
    String descricao,
    Widget imagem,
    Widget corpoHTML,
  ) {
    if (kDeviceType == EnumTipoDispositivo.mobile) {
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

    return _builderPaginaOrientacao(ehHTML, titulo, descricao, imagem, corpoHTML);
  }

  Widget _buildBotaoNavegacaoAdaptativo() {
    if (kDeviceType == EnumTipoDispositivo.mobile) {
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
              child: _buildBotoesNavegacao(),
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
            top: 50,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .12,
            child: _buildBotoesNavegacao(),
          ),
        );
      },
    );
  }

  _builderPaginaOrientacao(bool ehHTML, String titulo, String descricao, Widget imagem, Widget corpoHTML) {
    if (ehHTML) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .65,
        child: ListView(
          children: [corpoHTML],
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

  Widget _buildPaginacao() {
    return Observer(
      builder: (_) {
        return ListView.builder(
          itemCount: store.listaPaginasOrientacoes.length,
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
      },
    );
  }

  Widget _buildBotoesNavegacao() {
    bool ehUltimaDica = store.pagina == store.listaPaginasOrientacoes.length - 1;

    if (store.usuario.ultimoLogin != null && !ehUltimaDica) {
      return Column(
        children: [
          BotaoDefaultWidget(
            largura: 400,
            textoBotao: 'PRÓXIMA DICA',
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
            textoBotao: 'IR PARA A PÁGINA INICIAL',
            corDoTexto: TemaUtil.laranja01,
            onPressed: () {
              _irParaTelaInicial(context);
            },
          ),
        ],
      );
    } else if ((store.usuario.ultimoLogin != null || store.usuario.ultimoLogin == null) && ehUltimaDica) {
      return Column(
        children: [
          BotaoDefaultWidget(
            largura: 400,
            textoBotao: 'IR PARA A PÁGINA INICIAL',
            onPressed: () {
              _irParaTelaInicial(context);
            },
          ),
        ],
      );
    } else if (store.usuario.ultimoLogin == null && !ehUltimaDica) {
      return Column(
        children: [
          BotaoDefaultWidget(
            largura: 400,
            textoBotao: 'PRÓXIMA DICA',
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
    }

    return SizedBox();
  }
}
