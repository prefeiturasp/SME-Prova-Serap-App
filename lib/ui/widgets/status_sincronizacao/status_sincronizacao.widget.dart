import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/job_status.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/job.model.dart';
import 'package:appserap/ui/widgets/status_sincronizacao/status_sincronizacao.dialog.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/workers/jobs.enum.dart';
import 'package:flutter/material.dart';

class StatusSincronizacao extends StatelessWidget {
  const StatusSincronizacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: (() async {
          await mostrarDetalhesSincronizacaoResposta(context);
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
    );
  }
}
