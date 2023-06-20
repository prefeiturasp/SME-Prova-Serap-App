import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/arquivo_video.response.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/dtos/questao_completa_resposta.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';

import '../interfaces/database.interface.dart';
part 'questao_resultado_detalhes_view.store.g.dart';

class QuestaoResultadoDetalhesViewStore = _QuestaoResultadoDetalhesViewStoreBase
    with _$QuestaoResultadoDetalhesViewStore;

abstract class _QuestaoResultadoDetalhesViewStoreBase with Store, Loggable, Database {
  @observable
  bool carregando = false;

  @observable
  QuestaoCompletaRespostaResponseDto? detalhes;

  @observable
  QuestaoResponseDTO? questao;

  List<AlternativaResponseDTO> alternativas = [];

  List<ArquivoResponseDTO> imagens = [];

  List<ArquivoResponseDTO> audios = [];

  List<ArquivoVideoResponseDTO> videos = [];

  Prova? prova;

  @action
  Future<void> carregarDetalhesQuestao({required int provaId, required String caderno, required int questaoLegadoId}) async {
    carregando = true;

    prova ??= await db.provaDao.obterPorProvaIdECaderno(provaId, caderno);

    await retry(
      () async {
        var res = await ServiceLocator.get<ApiService>().provaResultado.getQuestaoCompleta(
              provaId: provaId,
              questaoLegadoId: questaoLegadoId,
            );

        if (res.isSuccessful) {
          detalhes = res.body!;
          await carregarDetalhes();
        } else {
          fine("Erro ao carregar detalhes da questão: ${res.error}");
        }
      },
      onRetry: (e) {
        fine(
            '[Prova $provaId] - Tentativa de carregamento detalhes da questão legado $questaoLegadoId - ${e.toString()}');
      },
    );
    carregando = false;
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
