import 'package:appserap/models/prova_alternativa.model.dart';
import 'package:appserap/models/prova_questao.model.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/views/login/login.view.dart';
import 'package:appserap/views/login/login.web.view.dart';
import 'package:appserap/widgets/base_state.dart';
import 'package:appserap/widgets/base_statefull.dart';
import 'package:appserap/widgets/inputs/botao_padrao.widget.dart';
import 'package:appserap/widgets/inputs/botao_secundario.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class ProvaView extends BaseStateful {
  const ProvaView() : super(title: "Prova");

  @override
  _ProvaViewState createState() => _ProvaViewState();
}

class _ProvaViewState extends BaseState<ProvaView, ProvaStore> {
  final _usuarioStore = GetIt.I.get<UsuarioStore>();
  final _provaStore = GetIt.I.get<ProvaStore>();

  final PageController listaQuestoesController = PageController(initialPage: 0);

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: TemaUtil.appBar,
      title: Observer(builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${_usuarioStore.nome} (${_usuarioStore.codigoEOL})",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "${_provaStore.prova!.descricao}",
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      }),
      actions: [
        Row(
          children: [
            TextButton(
              onPressed: () async {
                await _usuarioStore.limparUsuario();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => kIsWeb ? LoginWebView() : LoginView()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.exit_to_app_outlined, color: TemaUtil.laranja02),
                  SizedBox(width: 5),
                  Text("Sair", style: GoogleFonts.poppins(color: TemaUtil.laranja02)),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget builder(BuildContext context) {
    var questoes = _provaStore.provaCompleta!.questoes ?? [];

    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      controller: listaQuestoesController,
      onPageChanged: (value) {
        store.questaoAtual = value + 1;
      },
      itemCount: questoes.length,
      itemBuilder: (context, index) {
        return _buildQuestoes(questoes[index], index);
      },
    );
  }

  Widget _buildQuestoes(ProvaQuestaoModel questao, int index) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Observer(
                      builder: (context) {
                        return Text(
                          'Questão ${index + 1} ',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                    Text(
                      'de ${_provaStore.provaCompleta!.questoes!.length}',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    )
                  ],
                ),
                SizedBox(height: 8),
                HtmlWidget(
                  tratarArquivos(questao.titulo ?? ''),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  onTapImage: (ImageMetadata imageMetadata) {
                    print(imageMetadata);
                  },
                ),
                SizedBox(height: 8),
                HtmlWidget(
                  tratarArquivos(questao.descricao ?? ''),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  onTapImage: (ImageMetadata imageMetadata) {
                    print(imageMetadata);
                  },
                ),
                SizedBox(height: 16),
                _buildAlternativas(questao.id),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Observer(
                builder: (context) {
                  if (store.questaoAtual == 1) {
                    return SizedBox.shrink();
                  }

                  return BotaoSecundario(
                    textoBotao: 'Questão anterior',
                    onPressed: () {
                      listaQuestoesController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  );
                },
              ),
              Observer(
                builder: (context) {
                  if (store.questaoAtual < _provaStore.provaCompleta!.questoes!.length) {
                    return BotaoPadraoWidget(
                      textoBotao: 'Proxima questão',
                      onPressed: () {
                        listaQuestoesController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                        store.questaoAtual++;
                      },
                    );
                  }

                  return BotaoPadraoWidget(
                    textoBotao: 'Finalizar prova',
                    onPressed: () {
                      print('Finalizar prova');
                    },
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildAlternativas(int? questaoId) {
    // var alternativas =
    //     store.provaCompleta!.alternativas!.where((element) => element.questaoId == questaoId).toList();

    // print(alternativas);

    return Column(
      // children: alternativas.map((e) => _buildAlternativa(e.ordem, e.descricao)).toList(),
      children: [
        _buildAlternativa(1, 'A)', 'A comparação entre as brincadeiras de diferentes épocas.'),
        _buildAlternativa(2, 'B)', 'A comparação entre as brincadeiras de diferentes épocas.'),
        _buildAlternativa(3, 'C)', 'O humor do texto ao mostrar crianças com aparelhos tecnológicos.'),
        _buildAlternativa(4, 'D)', 'O desespero das crianças em ver o colega com um brinquedo novo.'),
      ],
    );
  }

  Widget _buildAlternativa(int? id, String? numeracao, String? texto) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black.withOpacity(0.34),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Observer(builder: (_) {
            return Radio<int?>(
              value: id,
              groupValue: store.resposta,
              onChanged: (value) => store.resposta = value,
            );
          }),
          Expanded(
            child: Text(
              "$numeracao $texto",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  String tratarArquivos(String texto) {
    RegExp exp = RegExp(r"#(\d+)#", multiLine: true, caseSensitive: true);
    var matches = exp.allMatches(texto).toList();

    for (var i = 0; i < matches.length; i++) {
      var arquivoId = texto.substring(matches[i].start, matches[i].end);
      var arquivo =
          _provaStore.provaCompleta!.arquivos!.where((arq) => arq.id == int.parse(arquivoId.split("#")[1])).first;
      var obterTipo = arquivo.caminho!.split(".");

      texto = texto.replaceAll(arquivoId, "data:image/${obterTipo[obterTipo.length - 1]};base64,${arquivo.base64}");
    }
    return texto;
    // #123456#
  }
}
