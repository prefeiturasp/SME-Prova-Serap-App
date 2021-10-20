import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'tabs/tabs/prova_atual_tab.view.dart';

class HomeView extends BaseStatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends BaseStateWidget<HomeView, HomeStore> with TickerProviderStateMixin {
  late TabController tabController;
  bool isLoad = false;

  @override
  void initState() {
    if (!isLoad) {
      tabController = TabController(
        initialIndex: 0,
        length: 1,
        vsync: this,
      );
      super.initState();
      setState(() {
        isLoad = true;
      });
    }
  }

  @override
  void dispose() {
    isLoad = false;
    tabController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      mostrarBotaoVoltar: false,
    );
  }

  @override
  Widget builder(BuildContext context) {
    final temaStore = GetIt.I.get<TemaStore>();

    return Observer(builder: (_) {
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: tabController,
              labelStyle: TextStyle(
                fontSize: temaStore.tTexto20,
                fontFamily: temaStore.fonteDoTexto,
                fontWeight: FontWeight.w600,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: TemaUtil.preto,
              unselectedLabelColor: TemaUtil.pretoSemFoco,
              isScrollable: true,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 4,
                  color: TemaUtil.laranja01,
                ),
              ),
              tabs: [
                Tab(
                  child: Observer(
                    builder: (_) {
                      return Texto(
                        'Prova atual',
                        texStyle: TemaUtil.temaTextoNumeracao.copyWith(
                          fontFamily: temaStore.fonteDoTexto,
                          fontSize: temaStore.tTexto20,
                        ),
                      );
                    },
                  ),
                ),
                // Tab(
                //   text: "Provas anteriores",
                // ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Observer(
                  builder: (_) {
                    return ProvaAtualTabView();
                  },
                ),
                // Container(),
              ],
            ),
          )
        ],
      );
    });
  }
}
