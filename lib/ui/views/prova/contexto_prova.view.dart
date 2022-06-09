import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/contexto_prova_view.store.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao_contexto.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:supercharged/supercharged.dart';

import '../../../main.route.dart';

class ContextoProvaView extends StatefulWidget {
  late final ProvaStore provaStore;

  ContextoProvaView({required int idProva}) {
    var provas = ServiceLocator.get<HomeStore>().provas;

    if (provas.isEmpty) {
      ServiceLocator.get<AppRouter>().router.go("/");
    }

    provaStore = provas.filter((prova) => prova.key == idProva).first.value;
  }

  @override
  _ContextoProvaViewState createState() => _ContextoProvaViewState();
}

class _ContextoProvaViewState extends State<ContextoProvaView> with Loggable {
  final store = GetIt.I.get<ContextoProvaViewStore>();

  @override
  void initState() {
    widget.provaStore.setRespondendoProva(true);
    store.carregarContextoProva(widget.provaStore.id);
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
              if (store.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ApresentacaoContextoWidget(
                listaDePaginasContexto: store.contextoProva,
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
