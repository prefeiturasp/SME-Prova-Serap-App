import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/views/login/login.view.dart';
import 'package:appserap/views/login/login.web.view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key}) : super(key: key);

  final _usuarioStore = GetIt.I.get<UsuarioStore>();
  final _provaStore = GetIt.I.get<ProvaStore>();

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: TemaUtil.appBar,
      title: Observer(builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${_usuarioStore.nome} (${_usuarioStore.codigoEOL})",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "${_provaStore.prova!.descricao}",
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      }),
      actions: [
        Row(
          children: [
            TextButton(
              onPressed: () async {
                await _usuarioStore.limparUsuario();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => kIsWeb ? LoginWebView() : LoginView()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.exit_to_app_outlined, color: TemaUtil.laranja02),
                  SizedBox(width: 5),
                  Text("Sair", style: GoogleFonts.poppins(color: TemaUtil.laranja02)),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
