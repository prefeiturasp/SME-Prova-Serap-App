import 'dart:async';
import 'dart:io';
import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/questao_resposta.dto.dart';
import 'package:appserap/models/resposta_prova.model.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:flutter/foundation.dart';

import 'package:cross_connectivity/cross_connectivity.dart';

import 'package:appserap/main.ioc.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/interfaces/worker.interface.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:workmanager/workmanager.dart';

class SincronizarRespostasWorker with Worker, Loggable {
  setup() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        return await Workmanager().registerPeriodicTask(
          "2",
          "SincronizarRespostasWorker",
          frequency: Duration(minutes: 15),
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
        );
      } else {
        return Timer.periodic(Duration(minutes: 15), (timer) {
          sincronizar();
        });
      }
    }

    Timer.periodic(Duration(minutes: 1), (timer) {
      sincronizar();
    });
  }

  @override
  onFetch(String taskId) async {
    fine('[Worker] Event received.');
    sincronizar();
  }

  Future<void> sincronizar([List<RespostaProva>? respostas]) async {
    fine('Sincronizando respostas para o servidor');

    AppDatabase db = ServiceLocator.get();

    var respostasParaSincronizar = respostas ?? await carregaRespostasNaoSincronizadas();
    fine('${respostasParaSincronizar.length} respostas ainda não sincronizadas');

    ConnectivityStatus resultado = await (Connectivity().checkConnectivity());
    if (respostasParaSincronizar.isNotEmpty && resultado == ConnectivityStatus.none) {
      info('Falha na sincronização. Sem Conexão....');
      return;
    }

    var respostasDTO = respostasParaSincronizar
        .map((e) => QuestaoRespostaDTO(
              alunoRa: e.codigoEOL,
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

          await db.respostaProvaDAO.definirSincronizado(resposta, true);
        }
      }
    } catch (e) {
      severe(e);
    }

    fine('Sincronização com o servidor servidor concluida');
  }

  Future<List> carregaRespostasNaoSincronizadas() async {
    AppDatabase db = ServiceLocator.get();
    return await db.respostaProvaDAO.obterTodasNaoSincronizadas();
  }
}
