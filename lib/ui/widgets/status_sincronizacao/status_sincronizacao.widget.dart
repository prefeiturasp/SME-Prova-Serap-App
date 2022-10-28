import 'package:appserap/enums/job_status.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/stores/job.store.dart';
import 'package:appserap/ui/widgets/status_sincronizacao/status_sincronizacao.dialog.dart';
import 'package:appserap/ui/widgets/texts/texto_default.widget.dart';
import 'package:appserap/workers/jobs.enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class StatusSincronizacao extends StatelessWidget {
  StatusSincronizacao({super.key});

  final jobStore = ServiceLocator.get<JobStore>();

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
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  )
                ],
              ),
              child: Observer(builder: (_) {
                var jobStatus = jobStore.statusJob[JobsEnum.SINCRONIZAR_RESPOSTAS];

                var status = Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 24,
                );

                switch (jobStatus) {
                  case EnumJobStatus.EXECUTANDO:
                    status = Icon(
                      Icons.sync,
                      color: Colors.grey,
                      size: 24,
                    );
                    break;

                  case EnumJobStatus.ERRO:
                    status = Icon(
                      Icons.cancel_rounded,
                      color: Colors.red,
                      size: 24,
                    );
                    break;

                  default:
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
