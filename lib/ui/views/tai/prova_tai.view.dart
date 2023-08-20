import 'package:appserap/main.route.gr.dart';
import 'package:appserap/stores/prova_tai.view.store.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

@RoutePage()
class ProvaTaiView extends BaseStatefulWidget {
  final int provaId;

  const ProvaTaiView({
    super.key,
    @PathParam('idProva') required this.provaId,
  });

  @override
  State<ProvaTaiView> createState() => _ProvaTaiViewState();
}

class _ProvaTaiViewState extends BaseStateWidget<ProvaTaiView, ProvaTaiViewStore> {
  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  void initState() {
    super.initState();
    store.configurarProva(widget.provaId).then((taiDisponivel) {
      if (taiDisponivel != null && taiDisponivel) {
        // Navegar para a questao informada na listagem de provas
        context.router.navigate(QuestaoTaiViewRoute(
          key: ValueKey("${store.provaStore!.id}-0"),
          provaId: store.provaStore!.id,
          ordem: 0,
        ));
      }
    });
  }

  @override
  Widget builder(BuildContext context) {
    return Observer(builder: (_) {
      if (store.carregando) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text("Carregando..."),
          ],
        );
      }

      if (!store.taiDisponivel) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Texto("Não é possível iniciar a prova pois não há conexão disponível."),
          ],
        );
      }

      return Container();
    });
  }
}
