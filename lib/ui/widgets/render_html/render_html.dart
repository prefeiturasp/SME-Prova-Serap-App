import 'dart:async';

import 'package:flutter/material.dart';

import 'flutter_html.dart';
import 'flutter_widget_from_html.dart';

enum RenderType {
  futer_html,
  flutter_widget_from_html,
}

class RenderHtml extends StatefulWidget {
  const RenderHtml({
    super.key,
    required this.html,
    required this.onImageTap,
    this.renderType = RenderType.flutter_widget_from_html,
  });

  final String html;
  final FutureOr<void> Function(String src) onImageTap;
  final RenderType renderType;

  @override
  State<RenderHtml> createState() => _RenderHtmlState();
}

class _RenderHtmlState extends State<RenderHtml> {
  @override
  Widget build(BuildContext context) {
    switch (widget.renderType) {
      case RenderType.futer_html:
        return FlutterHtml(
          html: widget.html,
          onImageTap: widget.onImageTap,
        );

      case RenderType.flutter_widget_from_html:
        return FlutterWidgetFromHtml(
          html: widget.html,
          onImageTap: widget.onImageTap,
        );
    }
  }
}
