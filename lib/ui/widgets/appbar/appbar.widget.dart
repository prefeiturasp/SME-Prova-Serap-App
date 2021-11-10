import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/stores/apresentacao.store.dart';
import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool popView;
  final String? subtitulo;
  final bool mostrarBotaoVoltar;

  final temaStore = GetIt.I<TemaStore>();

  AppBarWidget(
      {required this.popView, this.subtitulo, this.mostrarBotaoVoltar = true});

  final _principalStore = GetIt.I.get<PrincipalStore>();

  @override
  Size get preferredSize => Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    return _buildAppbarCompleta(context);
  }

  Widget _buildAppbarCompleta(BuildContext context) {
    return AppBar(
      title: Observer(
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "${_principalStore.usuario.nome} (${_principalStore.usuario.codigoEOL})",
                  style: TemaUtil.temaTextoAppBar.copyWith(
                    fontSize: temaStore.tTexto16,
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildSubtitulo(),
              ),
            ],
          );
        },
      ),
      automaticallyImplyLeading: false,
      actions: [
        TextButton(
          onPressed: () {
            mostrarDialogMudancaTema(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(TemaUtil.appBar),
          ),
          child: Observer(builder: (_) {
            return Text(
              "Aa",
              style: TextStyle(
                color: TemaUtil.laranja02,
                fontSize: temaStore.tTexto20,
                fontFamily: temaStore.fonteDoTexto.nomeFonte,
              ),
            );
          }),
        ),
        TextButton(
          onPressed: () async {
            await _principalStore.sair();

            if (popView) {
              var prova = GetIt.I.get<ProvaViewStore>();
              var orientacoes = GetIt.I.get<OrientacaoInicialStore>();
              var apresentacao = GetIt.I.get<ApresentacaoStore>();

              prova.dispose();
              orientacoes.dispose();
              apresentacao.dispose();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SplashScreenView()),
                (_) => false,
              );
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(TemaUtil.appBar),
          ),
          child: Row(
            children: [
              Icon(Icons.exit_to_app_outlined, color: TemaUtil.laranja02),
              SizedBox(width: 5),
              Observer(builder: (_) {
                return Text(
                  "Sair",
                  style: TextStyle(
                    fontFamily: temaStore.fonteDoTexto.nomeFonte,
                    fontSize: temaStore.tTexto16,
                    color: TemaUtil.laranja02,
                  ),
                );
              }),
              SizedBox(width: 5),
            ],
          ),
        ),
      ],
    );
  }

  _buildSubtitulo() {
    if (subtitulo != null) {
      return Observer(builder: (_) {
        return Text(
          subtitulo!,
          style: TextStyle(
            fontSize: temaStore.tTexto12,
            fontFamily: temaStore.fonteDoTexto.nomeFonte,
          ),
        );
      });
    }

    return SizedBox(
      height: 0,
    );
  }
}
