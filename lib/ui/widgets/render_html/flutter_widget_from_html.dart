import 'dart:async';

import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  TemaStore temaStore = ServiceLocator();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return HtmlWidget(
        widget.html,
        onTapImage: (ImageMetadata imageMetadata) async {
          await widget.onImageTap(imageMetadata.sources.first.url);
        },
        textStyle: TextStyle(
          fontSize: temaStore.tTexto16,
          fontFamily: temaStore.fonteDoTexto.nomeFonte,
        ),
      );
    });
  }
}
