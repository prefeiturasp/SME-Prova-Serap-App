import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/ui/views/prova/prova.view.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao.model.widget.dart';
import 'package:appserap/ui/widgets/apresentacao/apresentacao.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/bases/base_stateless.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ContextoProva extends BaseStatefulWidget {
  final ProvaStore provaStore;
  final List<ApresentacaoModelWidget> listaDePaginas;

  const ContextoProva({required this.listaDePaginas, required this.provaStore});

  @override
  _ContextoProvaState createState() => _ContextoProvaState();
}

class _ContextoProvaState extends BaseStatelessWidget<ContextoProva, HomeStore> with Loggable {
  @override
  Widget builder(BuildContext context) {
    return Observer(
      builder: (_) {
        
        return ApresentacaoWidget(
          listaDePaginas: widget.listaDePaginas,
          textoBotaoAvancar: "PRÓXIMA DICA",
          textoBotaoPular: "IR PARA A PROVA",
          regraMostrarTodosOsBotoesAoIniciar: false,
          regraMostrarApenasBotaoPoximo: true,
          pularSeNaoTiverConexao: false,
          flagExecutarFuncao: "prova",
          provaStore: widget.provaStore,
        );
      },
    );
  }
}
