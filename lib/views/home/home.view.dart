import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/views/home/tabs/prova_atual_tab.view.dart';
import 'package:appserap/views/home/tabs/provas_anteriores_tab.view.dart';
import 'package:appserap/views/login/login.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:appserap/stores/home.store.dart';
import 'package:appserap/widgets/bases/base_state.widget.dart';
import 'package:appserap/widgets/bases/base_statefull.widget.dart';

class HomeView extends BaseStatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends BaseStateWidget<HomeView, HomeStore>
    with TickerProviderStateMixin {
  final _usuarioStore = GetIt.I.get<UsuarioStore>();

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: TemaUtil.appBar,
      automaticallyImplyLeading: false,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Observer(
            builder: (_) {
              return Text(
                "${_usuarioStore.nome} (${_usuarioStore.codigoEOL})",
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              );
            },
          )
        ],
      ),
      actions: [
        Row(
          children: [
            TextButton(
              onPressed: () async {
                await _usuarioStore.limparUsuario();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginView(),
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.exit_to_app_outlined,
                    color: TemaUtil.laranja02,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Sair",
                    style: GoogleFonts.poppins(
                      color: TemaUtil.laranja02,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget builder(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: tabController,
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
            tabs: <Widget>[
              Tab(
                text: "Prova atual",
              ),
              Tab(
                text: "Provas anteriores",
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              ProvaAtualTabView(),
              ProvasAterioresTabView(),
            ],
          ),
        )
      ],
    );
  }
}
