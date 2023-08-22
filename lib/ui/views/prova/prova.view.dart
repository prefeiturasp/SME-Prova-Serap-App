import 'dart:async';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/main.route.gr.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

@RoutePage()
class ProvaView extends BaseStatefulWidget {
  final int idProva;

  const ProvaView({
    super.key,
    @PathParam('idProva') required this.idProva,
  }) : super(title: "Prova");

  @override
  _ProvaViewState createState() => _ProvaViewState();
}

class _ProvaViewState extends BaseStateWidget<ProvaView, ProvaViewStore> with Loggable {
  late ProvaStore provaStore;

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  double get defaultPadding => 0;

  @override
  bool get willPop => false;

  @override
  void initState() {
    store.isLoading = true;

    var provas = sl<HomeStore>().provas;

    if (provas.isEmpty) {
      sl<AppRouter>().navigate(HomeViewRoute());
    }

    provaStore = provas.filter((prova) => prova.key == widget.idProva).first.value;

    provaStore.configurarProva().then((_) async {
      Timer(Duration(milliseconds: 500), () {
        store.isLoading = false;
        sl<AppRouter>().navigate(
          QuestaoViewRoute(
            idProva: provaStore.id,
            ordem: 0,
          ),
        );
      });
    });

    store.setup(provaStore);

    super.initState();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {
    return Observer(builder: (context) {
      if (store.isLoading) {
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

      return SizedBox.shrink();
    });
  }
}
