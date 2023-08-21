import 'dart:convert';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/arquivo_video.response.dto.dart';
import 'package:appserap/dtos/prova_resultado_resumo_questao.response.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/dtos/questao_completa_resposta.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'questao_resultado_detalhes_view.store.g.dart';

@LazySingleton()
class QuestaoResultadoDetalhesViewStore = _QuestaoResultadoDetalhesViewStoreBase
    with _$QuestaoResultadoDetalhesViewStore;

abstract class _QuestaoResultadoDetalhesViewStoreBase with Store, Loggable {
  final AppDatabase db;
  final RespostasDatabase dbRespostas;
  final SharedPreferences _sharedPreferences;
  final ProvaResultadoService _provaResultadoService;

  @observable
  bool carregando = false;

  @observable
  int totalQuestoes = 0;

  @observable
  QuestaoCompletaRespostaResponseDto? detalhes;

  @observable
  QuestaoResponseDTO? questao;

  List<AlternativaResponseDTO> alternativas = [];

  List<ArquivoResponseDTO> imagens = [];

  List<ArquivoResponseDTO> audios = [];

  List<ArquivoVideoResponseDTO> videos = [];

  Prova? prova;

  _QuestaoResultadoDetalhesViewStoreBase(
    this.db,
    this.dbRespostas,
    this._sharedPreferences,
    this._provaResultadoService,
  );

  @action
  Future<void> carregarDetalhesQuestao({required int provaId, required String caderno, required int ordem}) async {
    carregando = true;

    prova ??= await db.provaDao.obterPorProvaIdECaderno(provaId, caderno);

    await retry(
      () async {
        totalQuestoes = calcularTotalQuestoes(_sharedPreferences, provaId, caderno);

        String key = 't-$provaId-$caderno-$ordem';

        var resumoQuestao =
            ProvaResultadoResumoQuestaoResponseDto.fromJson(jsonDecode(_sharedPreferences.getString(key)!));

        var res = await _provaResultadoService.getQuestaoCompleta(
          provaId: provaId,
          questaoLegadoId: resumoQuestao.idQuestaoLegado,
        );

        if (res.isSuccessful) {
          detalhes = res.body!;
          await carregarDetalhes();
        } else {
          fine("Erro ao carregar detalhes da questão: ${res.error}");
        }
      },
      onRetry: (e) {
        fine('[Prova $provaId] - Tentativa de carregamento detalhes da questão $ordem da prova - ${e.toString()}');
      },
    );
    carregando = false;
  }

  int calcularTotalQuestoes(SharedPreferences prefs, int idProva, String? nomeCaderno) {
    int total = 0;
    prefs.getKeys().forEach((element) {
      if (element.startsWith('t-$idProva-$nomeCaderno-')) {
        total++;
      }
    });
    return total;
  }

  @action
  limpar() {
    questao = null;
    alternativas = [];
    imagens = [];
    audios = [];
    videos = [];
  }

  @action
  carregarDetalhes() async {
    limpar();

    fine("Carregando ${detalhes!.questao.alternativas.length} alternativas");
    alternativas.addAll(detalhes!.questao.alternativas);

    fine("Carregando ${detalhes!.questao.arquivos.length} imagens");
    imagens.addAll(detalhes!.questao.arquivos);

    fine("Carregando ${detalhes!.questao.audios.length} audios");
    audios.addAll(detalhes!.questao.audios);

    fine("Carregando ${detalhes!.questao.videos.length} videos");
    videos.addAll(detalhes!.questao.videos);

    questao = detalhes!.questao.getQuestaoResponseDTO();
  }
}
