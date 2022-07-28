import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/questao_resposta.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/resposta_prova.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../main.ioc.dart';

part 'prova_resposta.store.g.dart';

class ProvaRespostaStore = _ProvaRespostaStoreBase with _$ProvaRespostaStore;

abstract class _ProvaRespostaStoreBase with Store, Loggable {
  final _service = GetIt.I.get<ApiService>().questaoResposta;
  final _serviceProva = GetIt.I.get<ApiService>().prova;

  final AppDatabase db = ServiceLocator.get();

  @observable
  int idProva;

  _ProvaRespostaStoreBase({required this.idProva});

  @observable
  String codigoEOL = ServiceLocator.get<UsuarioStore>().codigoEOL!;

  @observable
  ObservableMap<int, RespostaProva> respostasLocal = <int, RespostaProva>{}.asObservable();

  @action
  Future<void> carregarRespostasServidor() async {
    respostasLocal = (await carregarRespostasLocal()).asObservable();

    var connectionStatus = await Connectivity().checkConnectivity();
    if (connectionStatus == ConnectivityResult.none) {
      return;
    }

    fine('[Prova $idProva] - Carregando respostas da prova');

    try {
      var respostaBanco = await _serviceProva.getRespostasPorProvaId(idProva: idProva);

      if (respostaBanco.isSuccessful) {
        var questoesResponse = respostaBanco.body!;

        for (var questaoResponse in questoesResponse) {
          var entity = RespostaProva(
            codigoEOL: codigoEOL,
            provaId: idProva,
            questaoId: questaoResponse.questaoId,
            alternativaId: questaoResponse.alternativaId,
            resposta: questaoResponse.resposta,
            dataHoraResposta: questaoResponse.dataHoraResposta.toLocal(),
            sincronizado: true,
          );

          await db.respostaProvaDao.inserirOuAtualizar(entity);
          respostasLocal[questaoResponse.questaoId] = entity;

          finer(
            "[Prova $idProva] - (Questão ID ${questaoResponse.questaoId}) Resposta Remota ${questaoResponse.alternativaId} | ${questaoResponse.resposta}",
          );
        }

        fine('[Prova $idProva] - ${questoesResponse.length} respostas carregadas do banco de dados remoto');
      }
    } catch (e, stack) {
      if (!e.toString().contains("but got one of type 'String'") &&
          !e.toString().contains("is not a subtype of type")) {
        await recordError(e, stack);
      } else {
        finer('[Prova $idProva] Sem respostas salva');
      }
    }
  }

  RespostaProva? obterResposta(int questaoId) {
    return respostasLocal[questaoId];
  }

  @action
  sincronizarResposta({bool force = false}) async {
    fine('[$idProva] - Sincronizando respostas para o servidor');
    var respostasNaoSincronizadas = await db.respostaProvaDao.obterTodasNaoSincronizadasPorCodigoEProva(
      codigoEOL,
      idProva,
    );

    if (!ServiceLocator.get<PrincipalStore>().temConexao) {
      info("[$idProva] - Sincronização não executada. Não há conexão com a internet");
      return;
    }

    var prova = await ServiceLocator.get<AppDatabase>().provaDao.obterPorProvaId(idProva);

    if (respostasNaoSincronizadas.length == prova.quantidadeRespostaSincronizacao || force) {
      List<QuestaoRespostaDTO> respostas = [];

      for (var resposta in respostasNaoSincronizadas) {
        respostas.add(
          QuestaoRespostaDTO(
            alunoRa: codigoEOL,
            questaoId: resposta.questaoId,
            alternativaId: resposta.alternativaId,
            resposta: resposta.resposta,
            dataHoraRespostaTicks: getTicks(resposta.dataHoraResposta!),
            tempoRespostaAluno: resposta.tempoRespostaAluno,
          ),
        );
      }

      try {
        var response = await _service.postResposta(
          chaveAPI: AppConfigReader.getChaveApi(),
          respostas: respostas,
        );

        if (response.isSuccessful) {
          for (var resposta in respostasNaoSincronizadas) {
            fine("[$idProva] - Resposta Sincronizada - ${resposta.questaoId} | ${resposta.alternativaId}");
            await db.respostaProvaDao.definirSincronizado(resposta, true);
            respostasLocal[resposta.questaoId]!.sincronizado = true;
          }
        }
      } catch (e, stack) {
        await recordError(e, stack);
      }
    }

    fine('[$idProva] - Sincronização com o servidor servidor concluida');
  }

  @action
  Future<void> definirResposta(int questaoId, {int? alternativaId, String? textoResposta, int tempoQuestao = 0}) async {
    var resposta = RespostaProva(
      codigoEOL: codigoEOL,
      provaId: idProva,
      questaoId: questaoId,
      alternativaId: alternativaId,
      resposta: textoResposta,
      sincronizado: false,
      tempoRespostaAluno: tempoQuestao,
      dataHoraResposta: DateTime.now(),
    );

    await db.respostaProvaDao.inserirOuAtualizar(resposta);
    respostasLocal[questaoId] = resposta;
  }

  @action
  Future<void> definirTempoResposta(int questaoId, {int tempoQuestao = 0}) async {
    var resposta = obterResposta(questaoId);

    if (resposta != null) {
      resposta.sincronizado = false;
      resposta.tempoRespostaAluno += tempoQuestao;

      info('[$idProva] - Questao $questaoId - Tempo de resposta: ${resposta.tempoRespostaAluno} + $tempoQuestao');

      await db.respostaProvaDao.inserirOuAtualizar(resposta);
    } else {
      await definirResposta(questaoId, tempoQuestao: tempoQuestao);

      info('[$idProva] - Questao $questaoId - Tempo de resposta: $tempoQuestao');
    }
  }

  Future<Map<int, RespostaProva>> carregarRespostasLocal() async {
    var respostasBanco = await db.respostaProvaDao.obterPorProvaIdECodigoEOL(idProva, codigoEOL);

    Map<int, RespostaProva> respostas = {};

    for (var item in respostasBanco) {
      respostas[item.questaoId] = item;
    }

    return respostas;
  }
}
