import 'package:appserap/stores/login_adm.store.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginAdmView extends BaseStatefulWidget {
  final String codigo;

  LoginAdmView({
    Key? key,
    required this.codigo,
  }) : super(key: key);

  @override
  _LoginAdmViewState createState() => _LoginAdmViewState();
}

class _LoginAdmViewState extends BaseStateWidget<LoginAdmView, LoginAdmStore> {
  @override
  void initState() {
    super.initState();
    store.loginByToken(widget.codigo).then((logou) {
      if (logou) {
        context.go("/admin");
      }
    });
  }

  @override
  bool get showAppBar => false;

  @override
  Widget builder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Logando como administrador...'),
        SizedBox(height: 20),
        //CircularProgressIndicator(),
      ],
    );
  }
}
