import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/managers/download.manager.store.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/date.util.dart';
import 'package:appserap/utils/provas.util.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class BaixarProvaJob with Job, Loggable, Database {
  @override
  run() async {
    try {
      var _usuarioStore = ServiceLocator.get<UsuarioStore>();
      if (_usuarioStore.isRespondendoProva) {
        return;
      }

      String? token = ServiceLocator.get<SharedPreferences>().getString("token");
      if (token == null) {
        return;
      }

      ProvaService provaService = ServiceLocator.get<ApiService>().prova;

      var provasResponse = await provaService.getProvas();

      if (!provasResponse.isSuccessful) {
        return;
      }

      List<ProvaResponseDTO> provasRemoto = provasResponse.body!;
      List<int> idsProvasRemoto = provasRemoto.filter((e) => !e.isFinalizada()).map((e) => e.id).toList();

      List<int> idsProvasLocal = await getProvasCacheIds();
      List<int> idsToDownload = idsProvasRemoto.toSet().difference(idsProvasLocal.toSet()).toList();

      List<int> idsParaVerificar = idsProvasLocal.toSet().difference(idsToDownload.toSet()).toList();

      for (var idProva in idsParaVerificar) {
        Prova? provaLocal = await ServiceLocator.get<AppDatabase>().provaDao.obterPorIdNull(idProva);

        if (provaLocal == null) {
          continue;
        }
        var provaRemoto = provasRemoto.firstWhere((element) => element.id == provaLocal.id);

        // Caderno de questões alterado
        if (provaLocal.caderno != provaRemoto.caderno) {
          info("[Prova ${provaLocal.id}] - Caderno alterado ${provaLocal.caderno} -> ${provaRemoto.caderno}");
          await DownloadManagerStore(provaId: provaLocal.id).removerDownloadCompleto();
          idsToDownload.add(idProva);
        }

        // Prova não baixada
        if (provaLocal.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
          idsToDownload.add(idProva);
        }

        // Prova alterada
        if (!isSameDates(provaLocal.ultimaAlteracao, provaRemoto.ultimaAlteracao)) {
          info('[Prova ${provaLocal.id}] Prova alterada - Baixando Novamente...');
          await DownloadManagerStore(provaId: provaLocal.id).removerDownloadCompleto();
          idsToDownload.add(idProva);
        }
      }

      info('Encontrado ${idsToDownload.length} provas para baixar em segundo plano');
      for (var idProva in idsToDownload) {
        ProvaResponseDTO provaResumo = provasRemoto.firstWhere((element) => element.id == idProva);
        info('Prova ID: ${provaResumo.id} - ${provaResumo.descricao}');
      }

      for (var idProva in idsToDownload) {
        ProvaResponseDTO provaResumo = provasRemoto.firstWhere((element) => element.id == idProva);
        info('Iniciando download prova $idProva - ${provaResumo.descricao}');
        await _saveProva(provaResumo);

        DownloadManagerStore gerenciadorDownload = DownloadManagerStore(provaId: idProva, caderno: provaResumo.caderno);

        await gerenciadorDownload.iniciarDownload();

        info('Download concluido');
      }
    } catch (e, stack) {
      await recordError(e, stack);
    }
  }

  _saveProva(ProvaResponseDTO provaResponse) async {
    var prova = Prova(
      id: provaResponse.id,
      descricao: provaResponse.descricao,
      itensQuantidade: provaResponse.itensQuantidade,
      dataInicio: provaResponse.dataInicio,
      dataFim: provaResponse.dataFim,
      status: provaResponse.status,
      tempoExecucao: provaResponse.tempoExecucao,
      tempoExtra: provaResponse.tempoExtra,
      tempoAlerta: provaResponse.tempoAlerta,
      dataInicioProvaAluno: provaResponse.dataInicioProvaAluno,
      senha: provaResponse.senha,
      quantidadeRespostaSincronizacao: provaResponse.quantidadeRespostaSincronizacao,
      ultimaAlteracao: provaResponse.ultimaAlteracao,
      caderno: provaResponse.caderno,
    );

    await ServiceLocator.get<AppDatabase>().provaDao.inserirOuAtualizar(prova);
  }
}
