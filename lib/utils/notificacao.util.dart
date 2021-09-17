import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';

class NotificacaoUtil {
  static GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(SnackBar snackBar) {
    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static hideCurrentSnackBar() {
    messengerKey.currentState!.hideCurrentSnackBar();
  }

  static showSnackbarError(String mensagem) {
    final snackBar = SnackBar(
      content: Text(mensagem),
      duration: Duration(seconds: 30),
      action: SnackBarAction(
        label: 'Fechar',
        textColor: Colors.white,
        onPressed: () {
          hideCurrentSnackBar();
        },
      ),
      backgroundColor: TemaUtil.vermelhoErro,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: 350,
    );

    showSnackbar(snackBar);
  }
}
