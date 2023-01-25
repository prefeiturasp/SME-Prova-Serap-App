import 'package:appserap/stores/prova_tai.view.store.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class ProvaTaiView extends BaseStatefulWidget {
  final int provaId;

  const ProvaTaiView({
    super.key,
    required this.provaId,
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
        // Timer(Duration(milliseconds: 500), () {
        // Navegar para a questao informada na listagem de provas
        context.go("/prova/tai/${store.provaStore!.id}/questao/0");
        // });
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
