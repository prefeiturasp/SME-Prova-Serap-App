import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'base_statefull.widget.dart';

abstract class BaseStateWidget<TWidget extends BaseStatefulWidget, TBind extends Object> extends State<TWidget> {
  var store = GetIt.I.get<TBind>();
  var _principalStore = GetIt.I.get<PrincipalStore>();

  @override
  void initState() {
    super.initState();
    _principalStore.setup();
  }

  @override
  void dispose() {
    _principalStore.dispose();
    super.dispose();
  }

  bool showBottomNaviationBar = true;

  bool showAppBar = true;

  Widget? appBarTitleWidget;

  bool automaticallyImplyLeading = true;

  Color? backgroundColor;

  double defaultPadding = 16.0;

  bool? resizeToAvoidBottomInset;

  onAfterBuild(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => onAfterBuild(context));

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: showAppBar ? buildAppBar() : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
      persistentFooterButtons: _buildPersistentFooterButtons(),
      floatingActionButton: buildFloatingActionButton(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                top: defaultPadding,
                bottom: showBottomNaviationBar ? 0 : defaultPadding,
              ),
              child: builder(context),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBarWidget(
      popView: false,
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

            if (!_principalStore.temConexao) {
              cor = TemaUtil.vermelhoErro;
            }

            return Text(
              _principalStore.versao,
              style: TextStyle(color: cor),
            );
          },
        ),
      )
    ];
  }

  Widget builder(BuildContext context);
}
