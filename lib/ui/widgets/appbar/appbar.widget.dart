import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool popView;
  final String? subtitulo;
  final bool mostrarBotaoVoltar;

  AppBarWidget({required this.popView, this.subtitulo, this.mostrarBotaoVoltar = true});

  final _principalStore = GetIt.I.get<PrincipalStore>();

  @override
  Size get preferredSize => Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return _buildAppbarCompleta(context);
  }

  Widget _buildAppbarCompleta(BuildContext context) {
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
              _buildSubtitulo(),
            ],
          );
        },
      ),
      automaticallyImplyLeading: false,
      actions: [
        TextButton(
          onPressed: () async {
            await _principalStore.sair();

            if (popView) {
              var prova = GetIt.I.get<ProvaViewStore>();
              prova.dispose();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreenView()),
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
    );
  }

  _buildSubtitulo() {
    if (subtitulo != null) {
      return Text(
        subtitulo!,
        style: TextStyle(fontSize: 12),
      );
    }

    return SizedBox(
      height: 0,
    );
  }
}
