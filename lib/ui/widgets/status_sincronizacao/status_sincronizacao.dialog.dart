import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:appserap/enums/tipo_dispositivo.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/ui/widgets/adaptative/adaptative.widget.dart';
import 'package:appserap/ui/widgets/buttons/botao_terceario.widget.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/workers/jobs.enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

mostrarDetalhesSincronizacaoResposta(BuildContext context) async {
  bool conectado = ServiceLocator.get<PrincipalStore>().temConexao;

  AppDatabase db = ServiceLocator.get();
  RespostasDatabase dbRespostas = ServiceLocator.get();
  TemaStore temaStore = ServiceLocator.get();

  var job = await db.jobDao.getByJobName(JobsEnum.SINCRONIZAR_RESPOSTAS);
  var ultimaSincronizacao = formatDateddMMyyykkmmss(job?.ultimaExecucao);

  var totalSincronizadas = await dbRespostas.respostaProvaDao.getTotalSincronizadas();
  var totalTotalPendentes = await dbRespostas.respostaProvaDao.getTotalPendentes();

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
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
                  AdaptativeWidget(
                    mode: temaStore.incrementador >= 22 && kDeviceType != EnumTipoDispositivo.WEB
                        ? AdaptativeWidgetMode.COLUMN
                        : AdaptativeWidgetMode.ROW,
                    children: [
                      Texto(
                        'Respostas sincronizadas: ',
                        fontSize: 14,
                        bold: true,
                        color: TemaUtil.cinza02,
                      ),
                      Texto('$totalTotalPendentes', fontSize: 20, bold: true, color: TemaUtil.azul02),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  AdaptativeWidget(
                    mode: temaStore.incrementador >= 22 && kDeviceType != EnumTipoDispositivo.WEB
                        ? AdaptativeWidgetMode.COLUMN
                        : AdaptativeWidgetMode.ROW,
                    children: [
                      Texto(
                        'Respostas pendentes de sincronização: ',
                        fontSize: 14,
                        bold: true,
                        color: TemaUtil.cinza02,
                      ),
                      Texto('$totalSincronizadas', fontSize: 20, bold: true, color: TemaUtil.azul02),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  AdaptativeWidget(
                    mode: temaStore.incrementador >= 22 && kDeviceType != EnumTipoDispositivo.WEB
                        ? AdaptativeWidgetMode.COLUMN
                        : AdaptativeWidgetMode.ROW,
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
          ),
        );
      });
}
