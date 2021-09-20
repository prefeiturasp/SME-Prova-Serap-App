import 'package:appserap/dtos/autenticacao.dto.dart';
import 'package:appserap/stores/autenticacao.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _autenticacaoStore = GetIt.I.get<AutenticacaoStore>();
  final _principalStore = GetIt.I.get<PrincipalStore>();

  FocusNode _codigoEOLFocus = new FocusNode();
  FocusNode _senhaFocus = new FocusNode();

  @override
  void initState() {
    super.initState();
    _autenticacaoStore.setupValidations();
  }

  @override
  void dispose() {
    _codigoEOLFocus.dispose();
    _senhaFocus.dispose();
    _autenticacaoStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
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
                SvgPicture.asset("assets/images/logo-serap.svg"),
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
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextField(
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          focusNode: _codigoEOLFocus,
                          onChanged: (value) => _autenticacaoStore.codigoEOL = value,
                          decoration: InputDecoration(
                            labelText: 'Digite o código EOL',
                            labelStyle: TextStyle(
                              color: _codigoEOLFocus.hasFocus ? TemaUtil.laranja01 : TemaUtil.preto,
                            ),
                            prefixText: "RA-",
                            errorText: _autenticacaoStore.autenticacaoErroStore.codigoEOL,
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
                          borderRadius: new BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                          child: TextField(
                            obscureText: _autenticacaoStore.ocultarSenha,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => _autenticacaoStore.senha = value,
                            focusNode: _senhaFocus,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: _autenticacaoStore.ocultarSenha
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                color: TemaUtil.pretoSemFoco,
                                onPressed: () {
                                  _autenticacaoStore.ocultarSenha = !_autenticacaoStore.ocultarSenha;
                                },
                              ),
                              labelText: 'Digite a senha',
                              errorText: _autenticacaoStore.autenticacaoErroStore.senha,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Observer(
                  builder: (_) {
                    return _autenticacaoStore.carregando
                        ? Center(
                            child: Container(
                              child: CircularProgressIndicator(
                                backgroundColor: TemaUtil.laranja01,
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: () async {
                              _senhaFocus.unfocus();
                              _codigoEOLFocus.unfocus();

                              _autenticacaoStore.validateTodos();
                              if (!_autenticacaoStore.autenticacaoErroStore.possuiErros) {
                                await _autenticacaoStore.autenticar();
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
      ),
      persistentFooterButtons: [
        Center(
          child: Observer(
            builder: (_) {
              var cor = TemaUtil.preto;

              if (_principalStore.status == ConnectivityResult.none) {
                cor = TemaUtil.vermelhoErro;
              }

              return Text(
                "${_principalStore.versao}",
                style: TextStyle(
                  color: cor,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
