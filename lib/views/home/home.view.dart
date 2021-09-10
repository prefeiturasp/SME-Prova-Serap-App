import 'dart:convert';
import 'dart:developer';

import 'package:appserap/controllers/prova.controller.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/stores/login.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/splash_screen.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/views/home/paginas/prova_atual.page.dart';
import 'package:appserap/views/home/paginas/provas_anteriores.page.dart';
import 'package:appserap/views/login/login.view.dart';
import 'package:appserap/widgets/cards/prova_card.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/view-models/usuario_storage.viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final _usuarioStore = GetIt.I.get<UsuarioStore>();
  final _splashStore = GetIt.I.get<SplashScreenStore>();
  final _provaStore = GetIt.I.get<ProvaStore>();
  final _provaController = GetIt.I.get<ProvaController>();
  UsuarioStorageViewModel storage = new UsuarioStorageViewModel();
  List<ProvaModel> provas = <ProvaModel>[];
  String mensagem = "";

  int tabAtual = 0;

  lerMensagem() async {
    var prefs = await SharedPreferences.getInstance();
    var teste = prefs.getString("testeMensagem");
    setState(() {
      if (teste != null) {
        mensagem = teste;
      }
    });
  }

  List<Widget> _paginas = [
    ProvaAtualPage(),
    ProvasAterioresPage(),
  ];

  @override
  void initState() {
    _provaStore.limparProvas();
    obterProvas();
    //_homeController.obterVersaoDoApp();
    _usuarioStore.obterMensagem();
    lerMensagem();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _usuarioStore.obterMensagem();
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _usuarioStore.obterMensagem();
        lerMensagem();
        break;
      case AppLifecycleState.inactive:
        _usuarioStore.obterMensagem();
        lerMensagem();
        break;
      case AppLifecycleState.paused:
        _usuarioStore.obterMensagem();
        lerMensagem();
        break;
      default:
        _usuarioStore.obterMensagem();
        lerMensagem();
        break;
    }
  }

  obterProvas() async {
    //var prefs = await SharedPreferences.getInstance();
    var retorno = await _provaController.obterProvas();
    // for (var prova in retorno) {
    //   prefs.setString("prova_${prova.id}", jsonEncode(prova));
    // }
    setState(() {
      provas = retorno;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TemaUtil.appBar,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Observer(
              builder: (_) {
                return Text(
                  "${_usuarioStore.nome} (${_usuarioStore.codigoEOL})",
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold),
                );
              },
            )
          ],
        ),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () async {
                  await _usuarioStore.limparUsuario();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginView(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app_outlined,
                      color: TemaUtil.laranja02,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Sair",
                      style: GoogleFonts.poppins(
                        color: TemaUtil.laranja02,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                //
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tabAtual = 0;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Column(
                      children: [
                        Text(
                          "Prova atual",
                          style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: tabAtual == 0
                                  ? TemaUtil.preto
                                  : TemaUtil.pretoSemFoco),
                        ),
                        Visibility(
                          visible: tabAtual == 0,
                          child: Container(
                            height: 5,
                            color: TemaUtil.laranja02,
                            width: 145,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //
                GestureDetector(
                  onTap: () {
                    setState(() {
                      tabAtual = 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Column(
                      children: [
                        Text(
                          "Provas anteriores",
                          style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: tabAtual == 1
                                  ? TemaUtil.preto
                                  : TemaUtil.pretoSemFoco),
                        ),
                        Visibility(
                          visible: tabAtual == 1,
                          child: Container(
                            height: 5,
                            color: TemaUtil.laranja02,
                            width: 220,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _paginas[tabAtual]
        ],
      ),
      persistentFooterButtons: [
        Center(
          child: Observer(
            builder: (_) {
              return Text(
                "${_splashStore.versaoApp}",
              );
            },
          ),
        )
      ],
    );
  }
}
