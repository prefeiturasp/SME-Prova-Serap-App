import 'dart:convert';
import 'dart:typed_data';

import 'package:appserap/controllers/prova.controller.dart';
import 'package:appserap/models/prova_questao.model.dart';
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
  final _provaController = GetIt.I.get<ProvaController>();
  Uint8List bytes = new Uint8List(0);

  int paginaAtual = 0;
  final PageController listaQuestoesController = PageController(initialPage: 0);

  String imagemMock =
      "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";

  @override
  void initState() {
    super.initState();
  }

  String obterQuestaoAtual(ProvaQuestaoModel questao) {
    return '';
  }

  String removeTagHtml(String texto) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    var textoSemHtml = texto.replaceAll(exp, '').replaceAll('\n', ' ');
    return textoSemHtml.trim();
  }

  List<Widget> containerProva() {
    List<ProvaQuestaoModel> questoes =
        _provaStore.provaCompleta!.questoes ?? [];

    List<Widget> provas = [];

    questoes.forEach((questao) {
      provas.add(
        Column(
          children: [
            Text(
                'Questão ${questao.ordem} de ${_provaStore.provaCompleta!.itensQuantidade}'),
            Text(
              removeTagHtml(questao.titulo ?? ''),
            ),
            Container(
              height: 200,
              width: 200,
              child: Image.memory(
                base64Decode(imagemMock),
              ),
            ),
            Text(
              removeTagHtml(questao.descricao ?? ''),
            ),
            Container(
              height: 100,
              width: 400,
              color: Colors.blue[100],
              child: Center(
                child: Text('Componente múltipla escolhas'),
              ),
            ),
          ],
        ),
      );
    });

    return provas;
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
      body: Column(
        children: [
          Container(
            height: 600,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: listaQuestoesController,
              children: containerProva(),
            ),
          ),
          //
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: paginaAtual > 0,
                child: ElevatedButton(
                  onPressed: () {
                    listaQuestoesController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                    setState(() {
                      paginaAtual--;
                    });
                  },
                  child: Text('Questão anterior'),
                ),
              ),
              paginaAtual < _provaStore.provaCompleta!.itensQuantidade
                  ? ElevatedButton(
                      onPressed: () {
                        listaQuestoesController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                        setState(() {
                          paginaAtual++;
                        });
                      },
                      child: Text('Próxima questão'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        print('Finalizar prova');
                      },
                      child: Text('Finalizar prova'),
                    ),
            ],
          )
        ],
      ),
      persistentFooterButtons: [Text('Versão: 9999')],
    );
  }
}
