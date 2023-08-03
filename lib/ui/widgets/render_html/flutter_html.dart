import 'dart:async';

import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_all/flutter_html_all.dart';

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
  @override
  Widget build(BuildContext context) {
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
            color: TemaUtil.preto,
            fontSize: 16,
          ),
        ),
        'span': Style.fromTextStyle(
          TextStyle(
            fontSize: 16,
            color: TemaUtil.pretoSemFoco3,
          ),
        ),
      },
    );
  }
}
