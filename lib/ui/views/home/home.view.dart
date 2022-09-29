import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/job_status.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/job.model.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/ui/views/home/tabs/tabs/provas_anteriores_tab.view.dart';
import 'package:appserap/ui/widgets/appbar/appbar.widget.dart';
import 'package:appserap/ui/widgets/bases/base_state.widget.dart';
import 'package:appserap/ui/widgets/bases/base_statefull.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_default.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_terceario.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/workers/jobs.enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'tabs/tabs/prova_atual_tab.view.dart';

class HomeView extends BaseStatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends BaseStateWidget<HomeView, HomeStore> with TickerProviderStateMixin {
  late TabController tabController;
  bool isLoad = false;

  @override
  Color? get backgroundColor => TemaUtil.corDeFundo;

  @override
  void initState() {
    if (!isLoad) {
      tabController = TabController(
        initialIndex: 0,
        length: 2,
        vsync: this,
      );
      super.initState();
      setState(() {
        isLoad = true;
      });
    }
  }

  @override
  void dispose() {
    isLoad = false;
    tabController.dispose();
    super.dispose();
  }

  @override
  AppBarWidget buildAppBar() {
    return AppBarWidget(
      popView: true,
      mostrarBotaoVoltar: false,
      exibirSair: true,
    );
  }

  @override
  double get defaultPadding => 0;

  @override
  Widget builder(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: (() async {
              await mostrarInfo();
            }),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16, right: 16),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                      )
                    ],
                  ),
                  child: StreamBuilder<Job>(
                      stream: ServiceLocator.get<AppDatabase>().jobDao.watchJob(JobsEnum.SINCRONIZAR_RESPOSTAS),
                      builder: (context, snapshot) {
                        print('Status - ${snapshot.data}');

                        var status = Icon(
                          Icons.cancel_rounded,
                          color: Colors.red,
                          size: 24,
                        );

                        if (snapshot.hasData) {
                          if (snapshot.data!.statusUltimaExecucao == EnumJobStatus.COMPLETADO) {
                            status = Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 24,
                            );
                          } else if (snapshot.data!.statusUltimaExecucao == EnumJobStatus.EXECUTANDO) {
                            status = Icon(
                              Icons.sync,
                              color: Colors.grey,
                              size: 24,
                            );
                          }
                        }

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Texto(
                              "Sincronização:",
                              fontSize: 14,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            status,
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
          Padding(
            padding: getPadding(),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: tabController,
                labelStyle: TextStyle(
                  fontSize: temaStore.tTexto20,
                  fontFamily: temaStore.fonteDoTexto.nomeFonte,
                  fontWeight: FontWeight.w600,
                ),
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: TemaUtil.preto,
                unselectedLabelColor: TemaUtil.pretoSemFoco,
                isScrollable: true,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4,
                    color: TemaUtil.laranja01,
                  ),
                ),
                tabs: [
                  Tab(
                    child: Observer(
                      builder: (_) {
                        return Texto(
                          'Prova atual',
                          texStyle: TemaUtil.temaTextoNumeracao.copyWith(
                            fontFamily: temaStore.fonteDoTexto.nomeFonte,
                            fontSize: temaStore.tTexto20,
                          ),
                        );
                      },
                    ),
                  ),
                  Tab(
                    child: Texto(
                      'Provas anteriores',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                ProvaAtualTabView(),
                ProvasAnterioresTabView(),
              ],
            ),
          )
        ],
      );
    });
  }

  mostrarInfo() async {
    bool conectado = ServiceLocator.get<PrincipalStore>().temConexao;

    AppDatabase db = ServiceLocator.get();
    RespostasDatabase dbRespostas = ServiceLocator.get();

    var job = await db.jobDao.getByJobName(JobsEnum.SINCRONIZAR_RESPOSTAS);
    var ultimaSincronizacao = formatDateddMMyyykkmm(job?.ultimaExecucao);

    var totalSincronizadas = dbRespostas.respostaProvaDao.getTotalSincronizadas();
    var totalTotalPendentes = dbRespostas.respostaProvaDao.getTotalPendentes();

    List<Widget> statusConexao = [
      Icon(
        Icons.cancel_rounded,
        color: Colors.red,
        size: 24,
      ),
      SizedBox(
        height: 16,
      ),
      Texto(
        'Dispositivo sem conexão',
        fontSize: 18,
        color: Colors.red,
        bold: true,
      )
    ];

    if (conectado) {
      statusConexao = [
        Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 24,
        ),
        SizedBox(
          height: 16,
        ),
        Texto(
          'Dispositivo Conectado',
          fontSize: 18,
          color: Colors.green,
          bold: true,
        )
      ];
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Texto(
                    'Status de conexão com a internet:',
                    fontSize: 16,
                    bold: true,
                    color: TemaUtil.azul02,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: statusConexao,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    children: [
                      Texto(
                        'Respostas sincronizadas: ',
                        fontSize: 14,
                        bold: true,
                        color: TemaUtil.cinza02,
                      ),
                      Texto('0', fontSize: 20, bold: true, color: TemaUtil.azul02),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Texto(
                        'Respostas pendentes de sincronização: ',
                        fontSize: 14,
                        bold: true,
                        color: TemaUtil.cinza02,
                      ),
                      Texto('0', fontSize: 20, bold: true, color: TemaUtil.azul02),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Texto(
                        'Última sincronização de dados: ',
                        fontSize: 14,
                        bold: true,
                        color: TemaUtil.cinza02,
                      ),
                      Texto(ultimaSincronizacao, fontSize: 14, bold: true, color: TemaUtil.azul02),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  BotaoTercearioWidget(
                    largura: 112,
                    textoBotao: "Ok",
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
