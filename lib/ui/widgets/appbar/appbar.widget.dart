import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/modalidade.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool popView;
  final bool exibirSair;
  final String? subtitulo;
  final bool mostrarBotaoVoltar;
  final Widget? leading;

  final temaStore = GetIt.I<TemaStore>();

  AppBarWidget({
    required this.popView,
    this.subtitulo,
    this.mostrarBotaoVoltar = false,
    this.exibirSair = false,
    this.leading,
  });

  final _principalStore = GetIt.I.get<PrincipalStore>();

  @override
  Size get preferredSize => Size.fromHeight(78);

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15),
                child: Texto(
                  "${_principalStore.usuario.nome} (${_principalStore.usuario.codigoEOL})",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              !_principalStore.usuario.isAdmin
                  ? Texto(
                      "${_principalStore.usuario.modalidade.abreviacao} - ${_principalStore.usuario.turma} - ${_principalStore.usuario.escola} (${_principalStore.usuario.dreAbreviacao})",
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                  : Texto(
                      "",
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildSubtitulo(),
              ),
            ],
          );
        },
      ),
      automaticallyImplyLeading: false,
      leading: leading ?? (mostrarBotaoVoltar ? _buildBotaoVoltarLeading(context) : null),
      actions: [
        _buildAlterarFonte(context),
        exibirSair ? _buildBotaoSair(context) : Container(),
      ],
    );
  }

  Widget? _buildBotaoVoltarLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        context.pop();
      },
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

  _buildBotaoSair(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(TemaUtil.appBar),
      ),
      child: Icon(Icons.exit_to_app_outlined, color: TemaUtil.laranja02),
      onPressed: () async {
        bool sair = true;

        if (!kIsWeb) {
          sair = (await mostrarDialogSairSistema(context)) ?? false;
        }

        if (sair) {
          await _principalStore.sair();

          await ServiceLocator.get<HomeStore>().onDispose();

          if (popView) {
            var prova = GetIt.I.get<ProvaViewStore>();
            var orientacoes = GetIt.I.get<OrientacaoInicialStore>();

            prova.dispose();
            orientacoes.dispose();

            context.go("/splash");
          }
        }
      },
    );
  }

  _buildAlterarFonte(BuildContext context) {
    if (_principalStore.usuario.isAdmin) {
      return SizedBox.shrink();
    }

    return TextButton(
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
    );
  }
}
