import 'package:appserap/dtos/admin_questao_detalhes.response.dto.dart';
import 'package:appserap/dtos/alternativa.response.dto.dart';
import 'package:appserap/dtos/arquivo.response.dto.dart';
import 'package:appserap/dtos/arquivo_video.response.dto.dart';
import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api_service.dart';
import 'package:mobx/mobx.dart';
import 'package:retry/retry.dart';
part 'admin_prova_questao.store.g.dart';

class AdminProvaQuestaoViewStore = _AdminProvaQuestaoViewStoreBase with _$AdminProvaQuestaoViewStore;

abstract class _AdminProvaQuestaoViewStoreBase with Store, Loggable {
  @observable
  bool carregando = false;

  @observable
  AdminQuestaoDetalhesResponseDTO? detalhes;

  @observable
  QuestaoResponseDTO? questao;

  List<AlternativaResponseDTO> alternativas = [];

  List<ArquivoResponseDTO> imagens = [];

  List<ArquivoResponseDTO> audios = [];

  List<ArquivoVideoResponseDTO> videos = [];

  @action
  Future<void> carregarDetalhesQuestao(int idProva, int idQuestao) async {
    carregando = true;
    await retry(
      () async {
        var res = await ServiceLocator.get<ApiService>().admin.getDetalhes(idProva: idProva, idQuestao: idQuestao);

        if (res.isSuccessful) {
          detalhes = res.body!;
          await carregarDetalhes();
        } else {
          fine("Erro ao carregar detalhes da questão: ${res.error}");
        }
      },
      retryIf: (e) => e is Exception,
      onRetry: (e) {
        fine('[Prova $idProva] - Tentativa de carregamento detalhes da questão $idQuestao - ${e.toString()}');
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

    fine("Carregando ${detalhes!.alternativasId.length} alternativas");
    for (var id in detalhes!.alternativasId) {
      var res = await ServiceLocator.get<ApiService>().alternativa.getAlternativa(idAlternativa: id);
      if (res.isSuccessful) {
        alternativas.add(res.body!);
      }
    }

    fine("Carregando ${detalhes!.arquivosId.length} imagens");
    for (var id in detalhes!.arquivosId) {
      var res = await ServiceLocator.get<ApiService>().arquivo.getArquivo(idArquivo: id);
      if (res.isSuccessful) {
        imagens.add(res.body!);
      }
    }

    fine("Carregando ${detalhes!.audiosId.length} audios");
    for (var id in detalhes!.audiosId) {
      var res = await ServiceLocator.get<ApiService>().arquivo.getAudio(idArquivo: id);
      if (res.isSuccessful) {
        audios.add(res.body!);
      }
    }

    fine("Carregando ${detalhes!.videosId.length} videos");
    for (var id in detalhes!.videosId) {
      var res = await ServiceLocator.get<ApiService>().arquivo.getVideo(idArquivo: id);
      if (res.isSuccessful) {
        videos.add(res.body!);
      }
    }

    var res = await ServiceLocator.get<ApiService>().questao.getQuestao(idQuestao: detalhes!.questaoId);
    if (res.isSuccessful) {
      questao = res.body!;
    }
  }
}
