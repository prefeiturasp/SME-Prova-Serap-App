import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'base_statefull.widget.dart';

abstract class BaseStateWidget<TWidget extends BaseStatefulWidget, TBind extends Object> extends State<TWidget>
    with Loggable {
  var store = sl<TBind>();
  var principalStore = sl<PrincipalStore>();

  TemaStore temaStore = sl<TemaStore>();

  @override
  void initState() {
    super.initState();
    principalStore.setup();
  }

  @override
  void dispose() {
    principalStore.dispose();
    super.dispose();
  }

  bool showBottomNaviationBar = true;

  bool showAppBar = true;

  Widget? appBarTitleWidget;

  bool automaticallyImplyLeading = true;

  Color? backgroundColor;

  double defaultPadding = 16.0;
  double? defaultPaddingTop;

  bool willPop = true;

  bool? resizeToAvoidBottomInset;

  bool exibirSair = false;
  bool exibirVoltar = true;

  onAfterBuild(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onAfterBuild(context));

    return SafeArea(
      child: Observer(builder: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: backgroundColor,
          appBar: _showAppBar(),
          bottomNavigationBar: _buildBottomNavigationBar(),
          persistentFooterButtons: _buildPersistentFooterButtons(),
          floatingActionButton: buildFloatingActionButton(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: WillPopScope(
                  onWillPop: () async {
                    return willPop;
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: defaultPadding,
                      top: defaultPaddingTop ?? defaultPadding,
                      bottom: showBottomNaviationBar ? 0 : defaultPadding,
                    ),
                    child: builder(context),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  getPadding([EdgeInsets mobile = EdgeInsets.zero]) {
    if (kIsWeb) {
      return EdgeInsets.symmetric(
        horizontal: (MediaQuery.of(context).size.width - 600 - (24 * 2)) / 2,
      );
    } else {
      return mobile;
    }
  }

  PreferredSizeWidget? _showAppBar() {
    if (!showAppBar) {
      return null;
    }

    return PreferredSize(
      preferredSize: Size.fromHeight(temaStore.appbarHeight),
      child: buildAppBar(),
    );
  }

  AppBarWidget buildAppBar() {
    return AppBarWidget(
      popView: false,
      exibirSair: exibirSair,
      mostrarBotaoVoltar: exibirVoltar,
    );
  }

  Widget? buildLeading() {
    return null;
  }

  List<Widget>? buildActions() {
    return null;
  }

  Widget? buildFloatingActionButton() {
    return null;
  }

  Widget? _buildBottomNavigationBar() {
    return null;
  }

  List<Widget>? _buildPersistentFooterButtons() {
    return [
      Center(
        child: Observer(
          builder: (_) {
            var cor = TemaUtil.preto;

            if (!principalStore.temConexao) {
              cor = TemaUtil.vermelhoErro;
            }

            return Text(
              principalStore.versao,
              style: TextStyle(
                color: cor,
                fontSize: temaStore.tTexto14,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            );
          },
        ),
      )
    ];
  }

  Widget builder(BuildContext context);
}
