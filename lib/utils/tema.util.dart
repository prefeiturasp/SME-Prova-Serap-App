import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class TemaUtil {
  //! CORES
  static const corDeFundo = Color(0xFFFFF8F3);
  static const appBar = Color(0xFF2F304E);
  static const laranja01 = Color(0xFFFF7755);
  static const laranja02 = Color(0xFFF2945B);
  static const laranja03 = Color(0xFFE99312);
  static const laranja04 = Color(0xFFF9A82F);
  static const vermelhoErro = Color(0xFFF92F57);
  static const branco = Colors.white;
  static const cinza = Colors.grey;
  static const preto = Colors.black;
  static const pretoSemFoco = Colors.black54;
  static const pretoSemFoco2 = Colors.black38;
  static const azul = Colors.blue;
  static const azulScroll = Color(0xff10A1C1);
  static const verde01 = Colors.green;
  static const verde02 = Color(0xff62C153);

  //* TEMA DE TEXTOS
  static dynamic textoPrincipal(BuildContext context) {
    return GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
  }
}
