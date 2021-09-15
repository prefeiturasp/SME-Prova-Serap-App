import 'dart:convert';
import 'dart:typed_data';

import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/views/login/login.view.dart';
import 'package:appserap/views/login/login.web.view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class ProvaView extends StatefulWidget {
  const ProvaView({Key? key}) : super(key: key);

  @override
  _ProvaViewState createState() => _ProvaViewState();
}

class _ProvaViewState extends State<ProvaView> {
  final _usuarioStore = GetIt.I.get<UsuarioStore>();
  final _provaStore = GetIt.I.get<ProvaStore>();
  Uint8List bytes = new Uint8List(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TemaUtil.appBar,
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
            ),
            Observer(
              builder: (_) {
                return Text(
                  "${_provaStore.prova!.descricao}",
                  style: GoogleFonts.poppins(fontSize: 12),
                );
              },
            ),
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
                      builder: (context) =>
                          kIsWeb ? LoginWebView() : LoginView(),
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
      body: Container(
        height: 400,
        child: ListView.builder(
          itemCount: _provaStore.provaCompleta?.arquivos?.length,
          itemBuilder: (_, index) {
            var prova = _provaStore.provaCompleta!.arquivos![index];
            return Image.memory(base64Decode(prova.base64));
          },
        ),
      ),
      // body: Center(
      //   child: Column(
      //     children: [
      //       Text(
      //           "Alternativas ${_provaStore.provaCompleta?.alternativas?.length}"),
      //       Text("Questões ${_provaStore.provaCompleta?.questoes?.length}"),
      //       Text("Arquivos ${_provaStore.provaCompleta?.arquivos?.length}"),
      //       Container(
      //         child: bytes.isNotEmpty
      //             ? Image.memory(bytes)
      //             : SizedBox(
      //                 height: 10,
      //               ),
      //       ),
      //       BotaoPadraoWidget(
      //         textoBotao: "Baixar Imagem",
      //         largura: 200,
      //         onPressed: () async {
      //           var novaImagem = await _provaController
      //               .obterImagemPorId("c4ea385b-d1d2-4659-a9dc-79a174b088a9");
      //           setState(() {
      //             bytes = novaImagem;
      //           });
      //         },
      //       ),
      //       BotaoPadraoWidget(
      //         textoBotao: "Limpar Imagem",
      //         largura: 200,
      //         onPressed: () async {
      //           setState(() {
      //             bytes = new Uint8List(0);
      //           });
      //         },
      //       ),
      //       BotaoPadraoWidget(
      //         textoBotao: "Limpar Imagem cache",
      //         largura: 200,
      //         onPressed: () async {
      //           var prefs = await SharedPreferences.getInstance();
      //           prefs.remove("c4ea385b-d1d2-4659-a9dc-79a174b088a9");
      //           setState(() {
      //             bytes = new Uint8List(0);
      //           });
      //         },
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
