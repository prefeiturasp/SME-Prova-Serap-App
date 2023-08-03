import 'package:appserap/dtos/questao_resposta.dto.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/interfaces/job_config.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:workmanager/workmanager.dart';

class SincronizarRespostasJob extends Job with Loggable, Database {
  @override
  JobConfig configuration() {
    return JobConfig(
      frequency: Duration(minutes: 15),
      taskName: 'SincronizarRespostas',
      uniqueName: 'respostas-sincronizar',
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  @override
  run() async {
    fine('Sincronizando respostas para o servidor');

    var respostasParaSincronizar = await carregaRespostasNaoSincronizadas();
    fine('${respostasParaSincronizar.length} respostas ainda não sincronizadas');

    if (respostasParaSincronizar.isNotEmpty && !await InternetConnection().hasInternetAccess) {
      info('Falha na sincronização. Sem Conexão....');
      return;
    }

    var respostasDTO = respostasParaSincronizar
        .map((e) => QuestaoRespostaDTO(
              alunoRa: e.codigoEOL,
              dispositivoId: ServiceLocator.get<PrincipalStore>().dispositivoId,
              questaoId: e.questaoId,
              alternativaId: e.alternativaId,
              resposta: e.resposta,
              dataHoraRespostaTicks: getTicks(e.dataHoraResposta!),
              tempoRespostaAluno: e.tempoRespostaAluno,
            ))
        .toList();

    final _service = ServiceLocator.get<ApiService>().questaoResposta;

    try {
      var response = await _service.postResposta(
        chaveAPI: AppConfigReader.getChaveApi(),
        respostas: respostasDTO,
      );

      if (response.isSuccessful) {
        for (var resposta in respostasParaSincronizar) {
          fine("[${resposta.questaoId}] Resposta Sincronizada - ${resposta.alternativaId ?? resposta.resposta}");

          await dbRespostas.respostaProvaDao.definirSincronizado(resposta, true);
        }
      }
    } catch (e, stack) {
      await recordError(e, stack);
    }

    fine('Sincronização com o servidor servidor concluida');
  }

  Future<List> carregaRespostasNaoSincronizadas() async {
    return await dbRespostas.respostaProvaDao.obterTodasNaoSincronizadas();
  }
}
