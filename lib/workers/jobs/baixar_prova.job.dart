import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/managers/download.manager.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/utils/provas.util.dart';

class BaixarProvaJob with Loggable implements Job {
  @override
  run() async {
    try {
      ProvaService provaService = ServiceLocator.get<ApiService>().prova;

      var provasResponse = await provaService.getProvas();

      if (!provasResponse.isSuccessful) {
        return;
      }

      List<ProvaResponseDTO> provasRemoto = provasResponse.body!;
      List<int> idsProvasRemoto = provasRemoto.map((e) => e.id).toList();

      List<int> idsProvasLocal = getProvasCache();
      List<int> idsToDownload = idsProvasRemoto.toSet().difference(idsProvasLocal.toSet()).toList();

      List<int> idsParaVerificar = idsProvasLocal.toSet().difference(idsToDownload.toSet()).toList();

      for (var idProva in idsParaVerificar) {
        var prova = Prova.carregaProvaCache(idProva);

        if (prova == null) {
          continue;
        }

        if (prova.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
          idsToDownload.add(idProva);
        }
      }

      info('Encontrado ${idsToDownload.length} provas para baixar em segundo plano');

      for (var idProva in idsToDownload) {
        ProvaResponseDTO provaResumo = provasRemoto.firstWhere((element) => element.id == idProva);
        info('Iniciando download prova $idProva - ${provaResumo.descricao}');

        GerenciadorDownload gerenciadorDownload = GerenciadorDownload(idProva: idProva);

        await gerenciadorDownload.configure();

        await gerenciadorDownload.startDownload();
        info('Download concluido');
      }
    } catch (e, stacktrace) {
      severe(e);
      severe(stacktrace);
    }
  }
}
