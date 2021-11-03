import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tipo_dispositivo.enum.dart';
import 'package:appserap/stores/login.store.dart';
import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

class LoginView extends BaseStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends BaseStateWidget<LoginView, LoginStore> {
  FocusNode _codigoEOLFocus = FocusNode();
  FocusNode _senhaFocus = FocusNode();

  final _orientacaoStore = GetIt.I.get<OrientacaoInicialStore>();

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
          //
          _builderLogo(),
          //
          Observer(
            builder: (_) {
              return Text(
                "Bem-vindo",
                style: TemaUtil.temaTextoBemVindo.copyWith(
                  fontSize: temaStore.tTexto24,
                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                ),
              );
            },
          ),
          //
          _buildFormularioLogin(),
          //
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  Widget _builderLogo() {
    if (kDeviceType == EnumTipoDispositivo.mobile) {
      return Column(
        children: [
          SizedBox(
            height: 50,
          ),
          SvgPicture.asset(
            AssetsUtil.logoSerap,
            width: 150,
          ),
          SizedBox(
            height: 32,
          ),
        ],
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 150,
        ),
        SvgPicture.asset(AssetsUtil.logoSerap),
        SizedBox(
          height: 48,
        ),
      ],
    );
  }

  Widget _buildFormularioLogin() {
    var tela = TelaAdaptativaUtil();

    if (kDeviceType == EnumTipoDispositivo.mobile) {
      return Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(32, 20, 32, 10),
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      focusNode: _codigoEOLFocus,
                      onChanged: (value) => store.codigoEOL = value,
                      decoration: InputDecoration(
                        labelText: 'Digite o código EOL',
                        labelStyle: TextStyle(
                          color: _codigoEOLFocus.hasFocus ? TemaUtil.laranja01 : TemaUtil.preto,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
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
              padding: EdgeInsets.fromLTRB(32, 10, 32, 20),
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
                        labelStyle: TextStyle(
                          color: _senhaFocus.hasFocus ? TemaUtil.laranja01 : TemaUtil.preto,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
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
                  padding: EdgeInsets.symmetric(horizontal: 32),
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
                      child: Observer(
                        builder: (_) {
                          return Texto(
                            "ENTRAR",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            center: true,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
    return Form(
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    focusNode: _codigoEOLFocus,
                    onChanged: (value) => store.codigoEOL = value,
                    decoration: InputDecoration(
                      labelText: 'Digite o código EOL',
                      labelStyle: TextStyle(
                        color: _codigoEOLFocus.hasFocus ? TemaUtil.laranja01 : TemaUtil.preto,
                        fontFamily: temaStore.fonteDoTexto.nomeFonte,
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
                      labelStyle: TextStyle(
                        color: _senhaFocus.hasFocus ? TemaUtil.laranja01 : TemaUtil.preto,
                        fontFamily: temaStore.fonteDoTexto.nomeFonte,
                      ),
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
                    child: Observer(
                      builder: (_) {
                        return Texto(
                          "ENTRAR",
                          color: Colors.white,
                          fontSize: 16,
                          center: true,
                          fontWeight: FontWeight.w500,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
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
    await _orientacaoStore.popularListaDeOrientacoes();
  }
}
