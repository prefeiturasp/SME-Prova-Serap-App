import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

enum Variant { primary, secondary }

class Texto extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool bold;
  final Color? color;
  final bool italic;
  final int? maxLines;
  final TextOverflow textOverflow;
  final bool center;
  final Variant variant;
  final FontWeight? fontWeight;
  final TextStyle? texStyle;

  final _temaStore = GetIt.I.get<TemaStore>();

  Texto(
    this.text, {
    Key? key,
    this.fontSize = 10,
    this.bold = false,
    this.color,
    this.italic = false,
    this.maxLines,
    this.textOverflow = TextOverflow.ellipsis,
    this.center = false,
    this.variant = Variant.primary,
    this.fontWeight,
    this.texStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      TextStyle? style = texStyle;

      style ??= TextStyle(fontSize: fontSize, color: color);

      style = style.copyWith(
        fontSize: _temaStore.size(style.fontSize ?? fontSize),
        fontFamily: _temaStore.fonteDoTexto.nomeFonte,
        fontWeight: style.fontWeight ?? (fontWeight ?? (bold ? FontWeight.bold : FontWeight.normal)),
        color: style.color ?? (color ?? (variant == Variant.primary ? TemaUtil.preto : TemaUtil.pretoSemFoco)),
        fontStyle: style.fontStyle ?? (italic ? FontStyle.italic : null),
      );

      return Text(
        text,
        style: style,
        textAlign: _getTextAlign(),
        maxLines: maxLines,
        overflow: textOverflow,
      );
    });
  }

  TextAlign? _getTextAlign() {
    if (center) {
      return TextAlign.center;
    }

    return null;
  }
}
