import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/ui/views/home/tabs/tabs/provas_anteriores_tab.view.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  void initState() {
    if (!isLoad) {
      tabController = TabController(
        initialIndex: 0,
        length: 2,
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
      exibirSair: true,
    );
  }

  @override
  double get defaultPadding => 0;

  @override
  Widget builder(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: getPadding(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: tabController,
                labelStyle: TextStyle(
                  fontSize: temaStore.tTexto20,
                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
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
                            fontFamily: temaStore.fonteDoTexto.nomeFonte,
                            fontSize: temaStore.tTexto20,
                          ),
                        );
                      },
                    ),
                  ),
                  Tab(
                    child: Texto(
                      'Provas anteriores',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                ProvaAtualTabView(),
                ProvasAnterioresTabView(),
              ],
            ),
          )
        ],
      );
    });
  }
}
