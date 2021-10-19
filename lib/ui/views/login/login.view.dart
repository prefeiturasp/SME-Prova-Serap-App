import 'package:appserap/stores/login.store.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends BaseStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends BaseStateWidget<LoginView, LoginStore> {
  FocusNode _codigoEOLFocus = FocusNode();
  FocusNode _senhaFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    store.setupValidations();
  }

  @override
  void dispose() {
    _codigoEOLFocus.dispose();
    _senhaFocus.dispose();
    store.dispose();
    super.dispose();
  }

  @override
  bool get showAppBar => false;

  @override
  Widget builder(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 150,
          ),
          SvgPicture.asset(AssetsUtil.logoSerap),
          SizedBox(
            height: 48,
          ),
          Text(
            "Bem-vindo",
            style: TemaUtil.temaTextoBemVindo,
          ),
          SizedBox(
            height: 24,
          ),
          Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 392),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(15, 51, 51, 51),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Observer(
                        builder: (_) => TextField(
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          focusNode: _codigoEOLFocus,
                          onChanged: (value) => store.codigoEOL = value,
                          decoration: InputDecoration(
                            labelText: 'Digite o código EOL',
                            labelStyle: TextStyle(
                              color: _codigoEOLFocus.hasFocus ? TemaUtil.laranja01 : TemaUtil.preto,
                            ),
                            prefixText: "RA-",
                            errorText: store.autenticacaoErroStore.codigoEOL,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 392),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(15, 51, 51, 51),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Observer(
                        builder: (_) => TextField(
                          obscureText: store.ocultarSenha,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => store.senha = value,
                          focusNode: _senhaFocus,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: store.ocultarSenha ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                              color: TemaUtil.pretoSemFoco,
                              onPressed: () {
                                store.ocultarSenha = !store.ocultarSenha;
                              },
                            ),
                            labelText: 'Digite a senha',
                            errorText: store.autenticacaoErroStore.senha,
                          ),
                          onSubmitted: (value) => fazerLogin(),
                        ),
                      ),
                    ),
                  ),
                ),
                Observer(
                  builder: (_) {
                    if (store.carregando) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: TemaUtil.laranja01,
                        ),
                      );
                    }

                    return Container(
                      height: 50,
                      constraints: BoxConstraints(maxWidth: 392),
                      child: TextButton(
                        onPressed: () async {
                          fazerLogin();
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          // backgroundColor: MaterialStateProperty.all<Color>(TemaUtil.laranja01),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "ENTRAR",
                            textAlign: TextAlign.center,
                            style: TemaUtil.temaTextoBotao,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fazerLogin() async {
    _senhaFocus.unfocus();
    _codigoEOLFocus.unfocus();

    store.validateTodos();
    if (!store.autenticacaoErroStore.possuiErros) {
      await store.autenticar();
    }
  }
}
