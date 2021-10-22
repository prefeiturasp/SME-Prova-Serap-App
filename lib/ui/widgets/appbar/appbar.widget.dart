import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_enhanced/utils/utils.dart';

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
      leading: _buildBotaoVoltar(context),
      actions: [
        TextButton(
          onPressed: () async {
            await _principalStore.sair();

            if (popView) {
              var prova = GetIt.I.get<ProvaViewStore>();
              var orientacoes = GetIt.I.get<OrientacaoInicialStore>();

              prova.dispose();
              orientacoes.dispose();

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

  Widget _buildBotaoVoltar(BuildContext context) {
    if (mostrarBotaoVoltar) {
      return Observer(
        builder: (_) {
          var prova = GetIt.I.get<ProvaViewStore>();
          if (prova.revisandoProva) {
            return Container();
          }
          return IconButton(
            onPressed: () {
              if (!prova.revisandoProva) {
                Navigator.of(context).pop();
              }
              prova.dispose();
            },
            icon: Icon(
              Icons.arrow_back,
            ),
          );
        },
      );
    } else {
      return Container();
    }
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
