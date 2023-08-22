import 'package:appserap/main.route.gr.dart';
import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class OrientacaoInicialView extends StatefulWidget {
  const OrientacaoInicialView({Key? key}) : super(key: key);

  @override
  _OrientacaoInicialViewState createState() => _OrientacaoInicialViewState();
}

class _OrientacaoInicialViewState extends State<OrientacaoInicialView> {
  final _store = GetIt.I.get<OrientacaoInicialStore>();
  final _principalStore = GetIt.I.get<PrincipalStore>();
  final _usuario = GetIt.I.get<UsuarioStore>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: TemaUtil.corDeFundo,
        body: Padding(
          padding: getPadding(),
          child: Observer(
            builder: (_) {
              return ApresentacaoWidget(
                avancarParaPagina: HomeViewRoute(),
                listaDePaginas: _store.listaPaginasOrientacoes,
                textoBotaoAvancar: "PRÓXIMA DICA",
                textoBotaoPular: "IR PARA A PÁGINA INICIAL",
                regraMostrarTodosOsBotoesAoIniciar: _usuario.ultimoLogin != null,
                regraMostrarApenasBotaoPoximo: _usuario.ultimoLogin == null,
                pularSeNaoTiverConexao: !_principalStore.temConexao,
              );
            },
          ),
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

  EdgeInsets getPadding([EdgeInsets mobile = EdgeInsets.zero]) {
    if (kIsWeb) {
      return EdgeInsets.symmetric(
        horizontal: (MediaQuery.of(context).size.width - 600 - (24 * 2)) / 2,
      );
    } else {
      return mobile;
    }
  }
}
