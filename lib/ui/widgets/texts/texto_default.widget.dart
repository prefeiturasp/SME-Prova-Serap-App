import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum Variant { primary, secondary }

class TextoDefaultWidget extends StatelessWidget {
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

  const TextoDefaultWidget(
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight ?? (bold ? FontWeight.bold : FontWeight.normal),
        color: color ?? (variant == Variant.primary ? TemaUtil.preto : TemaUtil.pretoSemFoco),
        fontStyle: italic ? FontStyle.italic : null,
      ),
      textAlign: _getTextAlign(),
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }

  TextAlign? _getTextAlign() {
    if (center) {
      return TextAlign.center;
    }

    return null;
  }
}