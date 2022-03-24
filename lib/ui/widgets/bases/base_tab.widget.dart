import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:appserap/stores/principal.store.dart';

import 'base_statefull.widget.dart';

abstract class BaseTabWidget<TWidget extends BaseStatefulWidget, TBind extends Object> extends State<TWidget>
    with AutomaticKeepAliveClientMixin {
  var store = GetIt.I.get<TBind>();
  var _principalStore = GetIt.I.get<PrincipalStore>();

  @override
  bool get wantKeepAlive => true;

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

  onAfterBuild(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    WidgetsBinding.instance?.addPostFrameCallback((_) => onAfterBuild(context));

    return builder(context);
  }

  Widget builder(BuildContext context);

  getPadding([EdgeInsets mobile = EdgeInsets.zero]) {
    if (kIsWeb) {
      return EdgeInsets.symmetric(
        horizontal: (MediaQuery.of(context).size.width - 600 - (24 * 2)) / 2,
      );
    } else {
      return mobile;
    }
  }
}
