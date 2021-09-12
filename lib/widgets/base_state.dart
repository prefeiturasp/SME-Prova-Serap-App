import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'base_statefull.dart';

abstract class BaseState<TWidget extends BaseStateful, TBind extends Object> extends State<TWidget> {
  var store = GetIt.I.get<TBind>();

  bool showBottomNaviationBar = true;

  bool showAppBar = true;

  Widget? appBarTitleWidget;

  bool automaticallyImplyLeading = true;

  Color? backgroundColor;

  double defaultPadding = 16.0;

  bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: showAppBar ? buildAppBar() : null,
      bottomNavigationBar: buildBottomNaviationBar(),
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
    return AppBar(
      title: appBarTitleWidget ??
          Text(
            widget.title ?? "",
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: 24),
          ),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.orange),
      centerTitle: true,
      leading: buildLeading(),
      actions: buildActions(),
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

  Widget? buildBottomNaviationBar() {
    return null;
  }


  Widget builder(BuildContext context);
}

