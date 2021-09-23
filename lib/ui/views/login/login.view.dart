import 'package:appserap/stores/login.store.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/utils/icone.util.dart';
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
    Size screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Form(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
              SvgPicture.asset(IconeUtil.logoSerap),
              SizedBox(
                height: 10,
              ),
              Text(
                "Bem-vindo",
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Observer(
                builder: (_) => Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Container(
                    width: screenSize.width * .8,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(15, 51, 51, 51),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: TextField(
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
              Observer(
                builder: (_) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Container(
                      width: screenSize.width * .8,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(15, 51, 51, 51),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextField(
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
                        ),
                      ),
                    ),
                  );
                },
              ),
              Observer(
                builder: (_) {
                  return store.carregando
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: TemaUtil.laranja01,
                          ),
                        )
                      : TextButton(
                          onPressed: () async {
                            _senhaFocus.unfocus();
                            _codigoEOLFocus.unfocus();

                            store.validateTodos();
                            if (!store.autenticacaoErroStore.possuiErros) {
                              await store.autenticar();
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Container(
                              width: screenSize.width * .8,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: TemaUtil.laranja01,
                              ),
                              child: Center(
                                child: Text(
                                  "ENTRAR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: TemaUtil.branco,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
