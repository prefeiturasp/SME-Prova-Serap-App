import 'dart:async';

import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class FlutterWidgetFromHtml extends StatefulWidget {
  const FlutterWidgetFromHtml({
    super.key,
    required this.html,
    required this.onImageTap,
  });

  final String html;
  final FutureOr<void> Function(String url) onImageTap;

  @override
  State<FlutterWidgetFromHtml> createState() => _FlutterWidgetFromHtmlState();
}

class _FlutterWidgetFromHtmlState extends State<FlutterWidgetFromHtml> {
  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      widget.html,
      onTapImage: (ImageMetadata imageMetadata) async {
        await widget.onImageTap(imageMetadata.sources.first.url);
      },
      textStyle: TextStyle(
        color: TemaUtil.pretoSemFoco3,
        fontSize: 16,
      ),
    );
  }
}
