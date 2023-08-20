import 'dart:async';

import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_all/flutter_html_all.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FlutterHtml extends StatefulWidget {
  const FlutterHtml({
    super.key,
    required this.html,
    required this.onImageTap,
  });

  final String html;
  final FutureOr<void> Function(String url) onImageTap;

  @override
  State<FlutterHtml> createState() => _FlutterHtmlState();
}

class _FlutterHtmlState extends State<FlutterHtml> {
  TemaStore temaStore = sl();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Html(
          extensions: [
            // Audio e vídeo
            AudioHtmlExtension(),
            VideoHtmlExtension(),

            // Iframe
            IframeHtmlExtension(),

            // Math
            MathHtmlExtension(),

            // Imagem
            SvgHtmlExtension(),

            // Tabela
            TableHtmlExtension(),

            // Image Tap
            OnImageTapExtension(
              onImageTap: (src, imgAttributes, element) async {
                await widget.onImageTap(src!);
              },
            ),
          ],
          data: widget.html,
          style: {
            '*': Style.fromTextStyle(
              TextStyle(
                fontSize: temaStore.tTexto16,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            ),
            'span': Style.fromTextStyle(
              TextStyle(
                fontSize: temaStore.tTexto16,
                color: TemaUtil.pretoSemFoco3,
              ),
            ),
          },
        );
      },
    );
  }
}
