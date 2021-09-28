import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/ui/views/login/login.view.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool popView;

  AppBarWidget({required this.popView});

  final _principalStore = GetIt.I.get<PrincipalStore>();

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: TemaUtil.appBar,
      title: Observer(
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${_principalStore.usuario.nome} (${_principalStore.usuario.codigoEOL})",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // _provaStore.descricao != null
              //     ? Text(
              //         "${_provaStore.descricao}",
              //         style: TextStyle(fontSize: 12),
              //       )
              //     : SizedBox(
              //         height: 0,
              //       ),
            ],
          );
        },
      ),
      actions: [
        Row(
          children: [
            TextButton(
              onPressed: () async {
                await _principalStore.sair();

                if (popView) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginView()),
                    (_) => false,
                  );
                }
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
