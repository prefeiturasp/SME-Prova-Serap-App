import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao.widget.dart';
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
  final store = GetIt.I.get<OrientacaoInicialStore>();
  final _principalStore = GetIt.I.get<PrincipalStore>();

  final usuario = GetIt.I.get<UsuarioStore>();

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: TemaUtil.corDeFundo,
        body: Observer(
          builder: (_) {
            return ApresentacaoWidget(
              avancarParaPagina: HomeView(),
              listaDePaginas: store.listaPaginasOrientacoes,
              textoBotaoAvancar: "PRÓXIMA DICA",
              textoBotaoPular: "IR PARA A PÁGINA INICIAL",
              regraMostrarTodosOsBotoesAoIniciar: usuario.ultimoLogin != null,
              regraMostrarApenasBotaoPoximo: usuario.ultimoLogin == null,
            );
          },
        ),
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
}
