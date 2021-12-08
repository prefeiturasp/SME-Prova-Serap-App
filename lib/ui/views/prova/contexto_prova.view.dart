import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao_contexto.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class ContextoProvaView extends StatefulWidget {
  final ProvaStore provaStore;

  const ContextoProvaView({required this.provaStore});

  @override
  _ContextoProvaViewState createState() => _ContextoProvaViewState();
}

class _ContextoProvaViewState extends State<ContextoProvaView> with Loggable {
  final store = GetIt.I.get<HomeStore>();

  @override
  void initState() {
    widget.provaStore.setRespondendoProva(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: TemaUtil.corDeFundo,
        body: Padding(
          padding: getPadding(),
          child: Observer(
            builder: (_) {
              return ApresentacaoContextoWidget(
                listaDePaginasContexto: widget.provaStore.prova.contextosProva!,
                textoBotaoAvancar: "PRÓXIMA DICA",
                textoBotaoPular: "IR PARA A PROVA",
                regraMostrarTodosOsBotoesAoIniciar: false,
                regraMostrarApenasBotaoPoximo: true,
                provaStore: widget.provaStore,
              );
            },
          ),
        ),
      ),
    );
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
