import 'package:appserap/controllers/autenticacao.controller.dart';
import 'package:appserap/stores/login.store.dart';
import 'package:appserap/view-models/autenticar.viewmodel.dart';
import 'package:appserap/views/home/home.view.dart';
import 'package:appserap/stores/splash_screen.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/foundation.dart';
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
  final _formKey = GlobalKey<FormState>();
  FocusNode codigoEOLFocus = new FocusNode();
  FocusNode senhaFocus = new FocusNode();
  final _autenticacaoController = GetIt.I.get<AutenticacaoController>();
  var viewModel = new AutenticarViewModel();
  final _loginStore = GetIt.I.get<LoginStore>();
  final _splashStore = GetIt.I.get<SplashScreenStore>();

  bool _esconderSenha = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    codigoEOLFocus.dispose();
    super.dispose();
  }

  void limparCampoSenha() {
    setState(() {
      viewModel.senha = '';
      _loginStore.senhaController!.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Observer(
            builder: (_) => Column(
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
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Container(
                      width: screenSize.width * .8,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(15, 51, 51, 51),
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          focusNode: codigoEOLFocus,
                          decoration: InputDecoration(
                            errorText:
                                _loginStore.mensagemErroEOL.toString() != ''
                                    ? _loginStore.mensagemErroEOL.toString()
                                    : null,
                            prefixText: "RA-",
                            labelText: 'Digite o código EOL',
                            labelStyle: TextStyle(
                              color: codigoEOLFocus.hasFocus
                                  ? TemaUtil.laranja01
                                  : TemaUtil.preto,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Código EOL obrigatório';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            viewModel.codigoEOL = val!;
                          },
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Container(
                    width: screenSize.width * .8,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(15, 51, 51, 51),
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Observer(
                        builder: (_) => TextFormField(
                          controller: _loginStore.senhaController,
                          focusNode: senhaFocus,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _esconderSenha
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              color: TemaUtil.pretoSemFoco,
                              onPressed: () {
                                setState(() {
                                  _esconderSenha = !_esconderSenha;
                                });
                              },
                            ),
                            labelText: 'Digite a senha',
                            errorText:
                                _loginStore.mensagemErroSenha.toString() != ''
                                    ? _loginStore.mensagemErroSenha.toString()
                                    : null,
                          ),
                          obscureText: _esconderSenha,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Senha obrigatória';
                            }
                            if (value.length < 3) {
                              return 'A senha deve conter no mínimo 3 caracteres';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            viewModel.senha = val!;
                          },
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  ),
                ),
                viewModel.carregando
                    ? Center(
                        child: Container(
                          child: CircularProgressIndicator(
                            backgroundColor: TemaUtil.laranja01,
                          ),
                        ),
                      )
                    : Observer(
                        builder: (_) => TextButton(
                          onPressed: () async {
                            _loginStore.setMensagemErroEOL('');
                            _loginStore.setMensagemErroSenha('');
                            senhaFocus.unfocus();
                            codigoEOLFocus.unfocus();

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              final retorno = await _autenticacaoController
                                  .autenticar(viewModel);

                              if (retorno) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeView(),
                                  ),
                                );
                              } else {
                                limparCampoSenha();
                              }
                            } else {
                              limparCampoSenha();
                            }
                            setState(
                              () {
                                viewModel.carregando = false;
                              },
                            );
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
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        Center(
          child: Observer(
            builder: (_) => Text(
              "${_splashStore.versaoApp}",
            ),
          ),
        )
      ],
    );
  }
}
