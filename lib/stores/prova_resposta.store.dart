import 'dart:convert';

import 'package:appserap/dtos/questao_resposta.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/prova_resposta.model.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.ioc.dart';

part 'prova_resposta.store.g.dart';

class ProvaRespostaStore = _ProvaRespostaStoreBase with _$ProvaRespostaStore;

abstract class _ProvaRespostaStoreBase with Store, Loggable {
  final _service = GetIt.I.get<ApiService>().questaoResposta;
  final _serviceProva = GetIt.I.get<ApiService>().prova;

  @observable
  int idProva;

  _ProvaRespostaStoreBase({required this.idProva}) {
    respostasLocal = carregaRespostasCache().asObservable();
  }

  @observable
  String codigoEOL = ServiceLocator.get<UsuarioStore>().codigoEOL!;

  @observable
  ObservableMap<int, ProvaResposta> respostasLocal = <int, ProvaResposta>{}.asObservable();

  @action
  Future<void> carregarRespostasServidor([Prova? prova]) async {
    var connectionStatus = await Connectivity().checkConnectivity();
    if (connectionStatus == ConnectivityStatus.none) {
      return;
    }

    fine('[Prova $idProva] - Carregando respostas da prova');

    prova ??= await Prova.carregaProvaCache(idProva);

    try {
      var respostaBanco = await _serviceProva.getRespostasPorProvaId(idProva: idProva);

      if (respostaBanco.isSuccessful) {
        var questoesResponse = respostaBanco.body!;

        for (var questaoResponse in questoesResponse) {
          respostasLocal[questaoResponse.questaoId] = ProvaResposta(
            codigoEOL: codigoEOL,
            questaoId: questaoResponse.questaoId,
            sincronizado: true,
            alternativaId: questaoResponse.alternativaId,
            resposta: questaoResponse.resposta,
            dataHoraResposta: questaoResponse.dataHoraResposta.toLocal(),
          );

          finer(
            "[Prova $idProva] - (Questão ID ${questaoResponse.questaoId}) Resposta Banco Questao ${questaoResponse.alternativaId} | ${questaoResponse.resposta}",
          );
        }
      }
    } catch (e, stack) {
      if (!e.toString().contains("but got one of type 'String'") &&
          !e.toString().contains("type 'String' is not a subtype of type")) {
        severe(e);
        severe(stack);
      } else {
        finer('[Prova $idProva] Sem respostas salva');
      }
    }

    fine('[Prova $idProva] - ${respostasLocal.length} respostas carregadas do banco de dados remoto');
  }

  ProvaResposta? obterResposta(int questaoId) {
    return respostasLocal[questaoId];
  }

  @action
  sincronizarResposta({bool force = false}) async {
    fine('[$idProva] - Sincronizando respostas para o servidor');
    var respostasNaoSincronizadas = respostasLocal.entries.where((element) => element.value.sincronizado == false);

    var prova = await Prova.carregaProvaCache(idProva);

    if (respostasNaoSincronizadas.length == prova!.quantidadeRespostaSincronizacao || force) {
      List<QuestaoRespostaDTO> respostas = [];

      for (var item in respostasNaoSincronizadas) {
        int idQuestao = item.key;
        ProvaResposta resposta = item.value;

        respostas.add(
          QuestaoRespostaDTO(
            alunoRa: codigoEOL,
            questaoId: idQuestao,
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
          for (var resposta in respostas) {
            fine("[$idProva] - Resposta Sincronizada - ${resposta.questaoId} | ${resposta.alternativaId}");
            respostasLocal[resposta.questaoId]!.sincronizado = true;
          }
        }
      } catch (e) {
        severe(e);
      }
    }

    fine('[$idProva] - Sincronização com o servidor servidor concluida');

    salvarAllCache();
  }

  @action
  Future<void> definirResposta(int questaoId, {int? alternativaId, String? textoResposta, int? tempoQuestao}) async {
    var resposta = ProvaResposta(
      codigoEOL: codigoEOL,
      questaoId: questaoId,
      alternativaId: alternativaId,
      resposta: textoResposta,
      sincronizado: false,
      dataHoraResposta: DateTime.now().toUtc(),
      tempoRespostaAluno: tempoQuestao,
    );

    respostasLocal[questaoId] = resposta;

    await salvarCache(resposta);
  }

  @action
  Future<void> definirTempoResposta(int questaoId, {int? tempoQuestao}) async {
    var resposta = obterResposta(questaoId);

    if (resposta != null) {
      resposta.sincronizado = false;
      resposta.tempoRespostaAluno = tempoQuestao;
      await salvarCache(resposta);
    } else {
      await definirResposta(questaoId, tempoQuestao: tempoQuestao);
    }
  }

  salvarAllCache() async {
    List<Future<bool>> futures = [];

    for (var respostaLocal in respostasLocal.entries) {
      futures.add(salvarCache(respostaLocal.value));
    }

    await Future.wait(futures);
  }

  Future<bool> salvarCache(ProvaResposta resposta) async {
    SharedPreferences _pref = GetIt.I.get();

    var codigoEOL = ServiceLocator.get<UsuarioStore>().codigoEOL;

    return await _pref.setString(
      'resposta_${codigoEOL}_${resposta.questaoId}',
      jsonEncode(resposta.toJson()),
    );
  }

  Map<int, ProvaResposta> carregaRespostasCache() {
    SharedPreferences _pref = ServiceLocator.get();
    var codigoEOL = ServiceLocator.get<UsuarioStore>().codigoEOL;

    List<String> keysResposta =
        _pref.getKeys().toList().where((element) => element.startsWith('resposta_${codigoEOL}_')).toList();

    Map<int, ProvaResposta> respostas = {};

    if (keysResposta.isNotEmpty) {
      for (var keyResposta in keysResposta) {
        var provaResposta = ProvaResposta.fromJson(jsonDecode(_pref.getString(keyResposta)!));

        respostas[provaResposta.questaoId] = provaResposta;
      }
    }

    return respostas;
  }
}
