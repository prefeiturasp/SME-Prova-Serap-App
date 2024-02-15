import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.gr.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/appbar/popup_submenu_item.dart';
import 'package:appserap/ui/widgets/dialog/dialogs.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/workers/jobs.enum.dart';
import 'package:appserap/workers/jobs/finalizar_prova_pendente.job.dart';
import 'package:appserap/workers/jobs/remover_provas.job.dart';
import 'package:appserap/workers/jobs/sincronizar_respostas.job.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

class AppBarWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return _buildAppbarCompleta(context);
  }

  Widget _buildAppbarCompleta(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
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
        _buildDebugActions(context),
      ],
    );
  }

  Widget? _buildBotaoVoltarLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        context.router.pop();
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

          HomeStore homeStore = sl<HomeStore>();
          await homeStore.onDispose();

          if (popView) {
            var prova = GetIt.I.get<ProvaViewStore>();
            prova.dispose();

            var orientacoes = GetIt.I.get<OrientacaoInicialStore>();
            orientacoes.dispose();

            await context.router.navigate(SplashScreenViewRoute());
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

  _buildDebugActions(BuildContext context) {
    if (!kDebugMode) {
      return SizedBox.shrink();
    }

    return PopupMenuButton<String>(
        // add icon, by default "3 dot" icon
        // icon: Icon(Icons.book)
        itemBuilder: (context) {
      return [
        PopupMenuItem(
          value: 'resumo',
          child: ListTile(
            leading: Icon(Icons.clean_hands_rounded),
            title: Text('Ir para o resumo'),
          ),
        ),
        PopupMenuItem(
          value: 'banco',
          child: ListTile(
            leading: Icon(Icons.data_usage),
            title: Text('Banco Local'),
          ),
        ),
        PopupMenuItem(
          value: 'limpar',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Limpar banco'),
          ),
        ),
        PopupSubMenuItem(
          title: "Jobs",
          items: JobsEnum.values.map((e) => e.taskName).toList(),
          onSelected: (selected) async {
            var jobs = JobsEnum.parse(selected)!;
            switch (jobs) {
              case JobsEnum.SINCRONIZAR_RESPOSTAS:
                await SincronizarRespostasJob().run();
                break;

              case JobsEnum.FINALIZAR_PROVA:
                await FinalizarProvasPendenteJob().run();
                break;

              case JobsEnum.REMOVER_PROVAS_EXPIRADAS:
                await RemoverProvasJob().run();
                break;
            }
          },
        ),
      ];
    }, onSelected: (value) async {
      if (value == 'banco') {
        var directory = await getApplicationDocumentsDirectory();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DatabaseList(
              dbPath: directory.path,
            ),
          ),
        );
      } else if (value == 'limpar') {
        await sl<AppDatabase>().limparBanco();
        context.router.navigate(SplashScreenViewRoute());
      } else if (value == 'resumo') {
        var url = context.router.currentPath.split('/');

        context.router.navigate(ResumoRespostasViewRoute(idProva: int.parse(url[2])));
      }
    });
  }
}
