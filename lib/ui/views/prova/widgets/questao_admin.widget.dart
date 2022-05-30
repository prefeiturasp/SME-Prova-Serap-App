import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tipo_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:photo_view/photo_view.dart';

class QuestaoAdminWidget extends StatelessWidget {
  final TemaStore temaStore = ServiceLocator.get<TemaStore>();
  final controller = HtmlEditorController();

  final QuestaoResponseDTO questao;
  final List<ArquivoResponseDTO> imagens;
  final List<AlternativaResponseDTO> alternativas;

  QuestaoAdminWidget({
    Key? key,
    required this.questao,
    required this.imagens,
    required this.alternativas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Html(
          data: tratarArquivos(questao.titulo, imagens, EnumTipoImagem.QUESTAO),
          style: {
            '*': Style.fromTextStyle(
              TemaUtil.temaTextoHtmlPadrao.copyWith(
                fontSize: temaStore.tTexto16,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            ),
            'span': Style.fromTextStyle(
              TextStyle(
                  fontSize: temaStore.tTexto16,
                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  color: TemaUtil.pretoSemFoco3),
            ),
          },
          onImageTap: (url, _, attributes, element) {
            _exibirImagem(context, url!);
          },
        ),
        SizedBox(height: 8),
        Html(
          data: tratarArquivos(questao.descricao, imagens, EnumTipoImagem.QUESTAO),
          style: {
            '*': Style.fromTextStyle(
              TemaUtil.temaTextoHtmlPadrao.copyWith(
                fontSize: temaStore.tTexto16,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            ),
            'span': Style.fromTextStyle(
              TextStyle(
                fontSize: temaStore.tTexto16,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
                color: TemaUtil.pretoSemFoco3,
              ),
            ),
          },
          onImageTap: (url, _, attributes, element) {
            _exibirImagem(context, url!);
          },
        ),
        SizedBox(height: 16),
        _buildResposta(),
      ],
    );
  }

  Future<T?> _exibirImagem<T>(BuildContext context, String urlImagem) async {
    return await showDialog<T>(
      context: context,
      builder: (_) {
        var background = Colors.transparent;

        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.black.withOpacity(0.5),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: PhotoView(
                      backgroundDecoration: BoxDecoration(color: background),
                      imageProvider: NetworkImage(urlImagem),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.close, color: TemaUtil.laranja02),
                        SizedBox(
                          width: 8,
                        ),
                        Observer(
                          builder: (_) {
                            return Text(
                              'Fechar',
                              style: TemaUtil.temaTextoFecharImagem.copyWith(
                                fontSize: temaStore.tTexto18,
                                fontFamily: temaStore.fonteDoTexto.nomeFonte,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResposta() {
    switch (questao.tipo) {
      case EnumTipoQuestao.MULTIPLA_ESCOLHA:
        return _buildAlternativas();
      case EnumTipoQuestao.RESPOSTA_CONTRUIDA:
        return _buildRespostaConstruida();

      default:
        return SizedBox.shrink();
    }
  }

  _buildRespostaConstruida() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Texto(
              "Resposta Construida",
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  _buildAlternativas() {
    alternativas.sort((a, b) => a.ordem.compareTo(b.ordem));
    return ListTileTheme.merge(
      horizontalTitleGap: 0,
      child: Column(
        children: alternativas
            .map((e) => _buildAlternativa(
                  e.id,
                  e.numeracao,
                  e.descricao,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildAlternativa(int idAlternativa, String numeracao, String descricao) {
    return Observer(
      builder: (_) {
        return Container(
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
          child: ListTile(
            dense: true,
            title: Row(
              children: [
                Text(
                  "$numeracao ",
                  style: TemaUtil.temaTextoNumeracao.copyWith(
                    fontSize: temaStore.tTexto16,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
                Expanded(
                  child: Html(
                    data: tratarArquivos(descricao, imagens, EnumTipoImagem.ALTERNATIVA),
                    style: {
                      '*': Style.fromTextStyle(
                        TemaUtil.temaTextoPadrao.copyWith(
                          fontSize: temaStore.tTexto16,
                          fontFamily: temaStore.fonteDoTexto.nomeFonte,
                        ),
                      )
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String tratarArquivos(String? texto, List<ArquivoResponseDTO> arquivos, EnumTipoImagem tipoImagem) {
    if (texto == null) {
      return '';
    }

    if (tipoImagem == EnumTipoImagem.QUESTAO) {
      texto = texto.replaceAllMapped(RegExp(r'(<img[^>]*>)'), (match) {
        return '<div style="text-align: center; position:relative">${match.group(0)}<p><span>Toque na imagem para ampliar</span></p></div>';
      });
    }

    for (var arquivo in arquivos) {
      texto = texto!.replaceAll("#${arquivo.id}#", arquivo.caminho.replaceFirst('http://', 'https://'));
    }

    texto = texto!.replaceAll("#0#", AssetsUtil.notfound);

    return texto;
  }
}
