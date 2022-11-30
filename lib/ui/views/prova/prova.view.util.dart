import 'dart:convert';

import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tipo_imagem.enum.dart';
import 'package:appserap/enums/tratamento_imagem.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/questao.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/assets.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_all/flutter_html_all.dart';

abstract class ProvaViewUtil {
  buildTratamentoImagem(ProvaStore provaStore, List<Arquivo> imagens, Questao questao, List<Alternativa> alternativas) {
    if (imagens.isNotEmpty) {
      return Center(
        child: InkWell(
          onTap: () {
            var usuarioStore = ServiceLocator.get<UsuarioStore>();

            var html = _criarHTML(provaStore, imagens, questao, alternativas);

            if (html.isNotEmpty) {
              if (provaStore.ultimaAtualizacaoLogImagem == null ||
                  DateTime.now().difference(provaStore.ultimaAtualizacaoLogImagem!).inSeconds > 15) {
                ServiceLocator.get<ApiService>().log.logarNecessidadeDeUsoDaUrl(
                      chaveAPI: AppConfigReader.getChaveApi(),
                      prova: provaStore.id.toString(),
                      aluno: usuarioStore.codigoEOL!,
                      escola: usuarioStore.escola!,
                      html: html,
                    );

                provaStore.ultimaAtualizacaoLogImagem = DateTime.now();
              }
            }

            if (provaStore.tratamentoImagem == TratamentoImagemEnum.BASE64) {
              provaStore.tratamentoImagem = TratamentoImagemEnum.URL;
            } else {
              provaStore.tratamentoImagem = TratamentoImagemEnum.BASE64;
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.refresh, size: 14),
              Texto(" Caso não consiga visualizar a(s) imagem(s), clique aqui"),
            ],
          ),
        ),
      );
    }

    return Container();
  }

  String _criarHTML(ProvaStore provaStore, List<Arquivo> imagens, Questao questao, List<Alternativa> alternativas) {
    String html = "";

    if (questao.titulo != null) {
      if (questao.titulo!.contains(RegExp(r'#\d+#'))) {
        html += tratarArquivos(questao.titulo, imagens, EnumTipoImagem.QUESTAO, provaStore.tratamentoImagem);

        html += "<br><br>";
      }
    }

    if (questao.descricao.contains(RegExp(r'#\d+#'))) {
      html += tratarArquivos(questao.descricao, imagens, EnumTipoImagem.QUESTAO, provaStore.tratamentoImagem);

      html += "<br><br>";
    }

    for (var alternativa in alternativas) {
      if (alternativa.descricao.contains(RegExp(r'#\d+#'))) {
        html += tratarArquivos(alternativa.descricao, imagens, EnumTipoImagem.ALTERNATIVA, provaStore.tratamentoImagem);

        html += "<br><br>";
      }
    }

    return html;
  }

  String tratarArquivos(
    String? texto,
    List<Arquivo> arquivos,
    EnumTipoImagem tipoImagem,
    TratamentoImagemEnum tratamentoImagem,
  ) {
    if (texto == null) {
      return "";
    }

    if (tipoImagem == EnumTipoImagem.QUESTAO) {
      texto = texto.replaceAllMapped(RegExp(r'(<img[^>]*>)'), (match) {
        return '<div style="text-align: center; position:relative">${match.group(0)}<p><span>Toque na imagem para ampliar</span></p></div>';
      });
    }

    for (var arquivo in arquivos) {
      switch (tratamentoImagem) {
        case TratamentoImagemEnum.BASE64:
          var obterTipo = arquivo.caminho.split(".");
          texto = texto!.replaceAll(
            "#${arquivo.legadoId}#",
            "data:image/${obterTipo[obterTipo.length - 1]};base64,${arquivo.base64}",
          );
          break;
        case TratamentoImagemEnum.URL:
          texto = texto!.replaceAll(
            "#${arquivo.legadoId}#",
            arquivo.caminho,
          );
          break;
      }
    }

    texto = texto!.replaceAll("#0#", AssetsUtil.notfound);

    return texto;
  }

  Widget renderizarHtml(
    BuildContext context,
    String? texto,
    List<Arquivo> imagens,
    EnumTipoImagem tipoImagem,
    TratamentoImagemEnum tratamentoImagem,
  ) {
    TemaStore temaStore = ServiceLocator.get<TemaStore>();
    CustomRenderMatcher texMatcher() => (context) => context.tree.element?.localName == 'tex';

    return Html(
      customRenders: {
        // Audio e vídeo
        audioMatcher(): audioRender(),
        videoMatcher(): videoRender(),
        // Iframe
        iframeMatcher(): iframeRender(),
        // Math
        mathMatcher(): mathRender(),
        // Imagem
        svgTagMatcher(): svgTagRender(),
        svgDataUriMatcher(): svgDataImageRender(),
        svgAssetUriMatcher(): svgAssetImageRender(),
        svgNetworkSourceMatcher(): svgNetworkImageRender(),
        // Tabela
        tableMatcher(): tableRender(),
        // Tex
        texMatcher(): CustomRender.widget(
          widget: (context, buildChildren) => Math.tex(
            context.tree.element?.innerHtml ?? '',
            mathStyle: MathStyle.display,
            textStyle: context.style.generateTextStyle(),
            onErrorFallback: (FlutterMathException e) {
              return Text(e.message);
            },
          ),
        ),
      },
      data: tratarArquivos(texto, imagens, tipoImagem, tratamentoImagem),
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
      onImageTap: (url, _, attributes, element) async {
        await _exibirImagem(context, url);
      },
    );
  }

  Future<Uint8List> networkAssetBundleFromUrl(String url) async {
    final uri = Uri.parse(url);
    final Response response = await get(uri);
    return response.bodyBytes;
  }

  Future<T?> _exibirImagem<T>(BuildContext context, String? url) async {
    late Uint8List imagem;

    if (url!.startsWith('http')) {
      imagem = await networkAssetBundleFromUrl(url.replaceFirst('http://', 'https://'));
    } else {
      imagem = base64.decode(url.split(',').last);
    }

    TemaStore temaStore = ServiceLocator.get<TemaStore>();

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
                      imageProvider: MemoryImage(imagem),
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
}
