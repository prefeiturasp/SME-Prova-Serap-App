import 'package:appserap/stores/home.store.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tabs/tabs/prova_atual_tab.view.dart';

class HomeView extends BaseStatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends BaseStateWidget<HomeView, HomeStore> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    store.carregarProvas();
    tabController = TabController(
      initialIndex: 0,
      length: 1,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget builder(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: tabController,
            labelStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
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
                text: "Prova atual",
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
              ProvaAtualTabView(),
            ],
          ),
        )
      ],
    );
  }
}
