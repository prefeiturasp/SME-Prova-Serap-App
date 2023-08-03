import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/interfaces/job_config.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/workers/jobs/sincronizar_respostas.job.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:workmanager/workmanager.dart';

class FinalizarProvasPendenteJob with Job, Loggable, Database {
  @override
  JobConfig configuration() {
    return JobConfig(
      frequency: Duration(minutes: 15),
      taskName: 'FinalizarProvasPendentes',
      uniqueName: 'provas-finalizar-pendentes',
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  @override
  run() async {
    AppDatabase db = ServiceLocator.get();

    fine('Sincronizando provas para o servidor');

    List<Prova> provas = await db.provaDao.obterPendentes();

    info('${provas.length} provas pendente de sincronização');

    if (provas.isNotEmpty && !await InternetConnection().hasInternetAccess) {
      info('Falha na sincronização. Sem Conexão....');
      return;
    }

    for (var prova in provas) {
      try {
        // Atualiza status servidor
        await ServiceLocator.get<ApiService>().prova.setStatusProva(
              idProva: prova.id,
              status: EnumProvaStatus.FINALIZADA.index,
              tipoDispositivo: kDeviceType.index,
              dataInicio: getTicks(prova.dataInicioProvaAluno!),
              dataFim: getTicks(prova.dataFimProvaAluno!),
            );

        // Sincroniza respostas
        info('Sincronizando  respostas');
        await SincronizarRespostasJob().run();

        // Remove respostas do banco local
        await dbRespostas.respostaProvaDao.removerSincronizadasPorProva(prova.id);

        // Atualiza Status da prova
        await db.provaDao.atualizarStatus(prova.id, prova.caderno, EnumProvaStatus.FINALIZADA);
      } catch (e, stack) {
        await recordError(e, stack);
      }
    }
    fine('Sincronização com o servidor servidor concluida');
  }
}
