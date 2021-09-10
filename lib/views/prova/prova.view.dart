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
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
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

  @override
  void initState() {
    super.initState();
  }

  String obterQuestaoAtual(ProvaQuestaoModel questao) {
    return '';
  }

  List<Widget> containerProva() {
    List<ProvaQuestaoModel> questoes =
        _provaStore.provaCompleta!.questoes ?? [];

    List<Widget> provas = [];

    questoes.forEach((questao) {
      provas.add(
        SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                    'Questão ${questao.ordem} de ${_provaStore.provaCompleta!.itensQuantidade}'),
                HtmlWidget(
                  tratarArquivos(questao.titulo ?? ''),
                ),
                HtmlWidget(
                  tratarArquivos(questao.descricao ?? ''),
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
          ),
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

  String tratarArquivos(String texto) {
    RegExp exp = RegExp(r"#(\d+)#", multiLine: true, caseSensitive: true);
    var matches = exp.allMatches(texto).toList();

    for (var i = 0; i < matches.length; i++) {
      var arquivoId = texto.substring(matches[i].start, matches[i].end);
      var arquivo = _provaStore.provaCompleta!.arquivos!
          .where((arq) => arq.id == int.parse(arquivoId.split("#")[1]))
          .first;
      var obterTipo = arquivo.caminho!.split(".");

      texto = texto.replaceAll(arquivoId,
          "data:image/${obterTipo[obterTipo.length - 1]};base64,${arquivo.base64}");
    }
    return texto;
    // #123456#
  }
}
