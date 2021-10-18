import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_secundario.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OrientacaoInicialView extends BaseStatefulWidget {
  const OrientacaoInicialView({Key? key}) : super(key: key);

  @override
  _OrientacaoInicialViewState createState() => _OrientacaoInicialViewState();
}

class _OrientacaoInicialViewState extends BaseStateWidget<OrientacaoInicialView, OrientacaoInicialStore> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final ScrollController _controllerDicas = ScrollController();

  void _irParaTelaInicial(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeView()),
    );
  }

  @override
  bool get showAppBar => false;

  @override
  void initState() {
    
    super.initState();
  }

  Widget _buildBotoesNavegacao() {
    bool ehUltimaDica = store.pagina == store.listaPaginasOrientacoes.length - 1;

    if (store.usuario.ultimoLogin != null && !ehUltimaDica) {
      return Column(
        children: [
          BotaoDefaultWidget(
            textoBotao: 'PRÓXIMA DICA',
            onPressed: () {
              store.pagina++;
              introKey.currentState?.next();
            },
          ),
          BotaoSecundarioWidget(
            textoBotao: 'IR PARA A PÁGINA INICIAL',
            corDoTexto: TemaUtil.laranja01,
            onPressed: () {
              _irParaTelaInicial(context);
            },
          ),
        ],
      );
    } else if (store.usuario.ultimoLogin != null && ehUltimaDica) {
      return Column(
        children: [
          BotaoDefaultWidget(
            textoBotao: 'IR PARA A PÁGINA INICIAL',
            onPressed: () {
              _irParaTelaInicial(context);
            },
          ),
        ],
      );
    } else if (store.usuario.ultimoLogin == null && ehUltimaDica) {
      return Column(
        children: [
          BotaoDefaultWidget(
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
            textoBotao: 'PRÓXIMA DICA',
            onPressed: () {
              store.pagina++;
              introKey.currentState?.next();
            },
          ),
        ],
      );
    }

    return SizedBox();
  }

  @override
  Widget builder(BuildContext context) {
    
    return Observer(builder: (_) {
      return IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,

        globalFooter: SizedBox(
          height: MediaQuery.of(context).size.width * .25,
          width: MediaQuery.of(context).size.width * .8,
          child: _buildBotoesNavegacao(),
        ),

        pages: store.listaPaginasOrientacoes,
        scrollController: _controllerDicas,

        showSkipButton: false,
        showDoneButton: false,
        showNextButton: false,
        skipFlex: 0,
        nextFlex: 0,
        onChange: (page) {
          store.pagina = page;
        },
        //rtl: true, // Display as right-to-left
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb ? const EdgeInsets.all(12.0) : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Colors.black38,
          activeColor: Color(0xff10A1C1),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
        ),
      );
    });
  }
}
