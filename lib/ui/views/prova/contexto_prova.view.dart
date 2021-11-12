import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao.model.widget.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao.widget.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao_contexto.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/bases/base_stateless.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ContextoProvaView extends BaseStatefulWidget {
  final ProvaStore provaStore;

  const ContextoProvaView({required this.provaStore});

  @override
  _ContextoProvaViewState createState() => _ContextoProvaViewState();
}

class _ContextoProvaViewState extends BaseStatelessWidget<ContextoProvaView, HomeStore> with Loggable {
  @override
  Widget builder(BuildContext context) {
    return Observer(
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
    );
  }
}
