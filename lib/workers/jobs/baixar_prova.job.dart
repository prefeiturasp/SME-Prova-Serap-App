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
import 'package:appserap/utils/firebase.util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaixarProvaJob extends Job with Loggable, Database {
  @override
  run() async {
    try {
      var _usuarioStore = sl.get<UsuarioStore>();
      if (_usuarioStore.isRespondendoProva) {
        return;
      }
      var prefs = sl<SharedPreferences>();

      String? token = prefs.getString("token");
      String? codigoEol = prefs.getString("serapUsuarioCodigoEOL");
      if (token == null || codigoEol == null) {
        return;
      }

      ProvaService provaService = sl<ProvaService>();

      var provasResponse = await provaService.getProvas();

      if (!provasResponse.isSuccessful) {
        return;
      }

      List<ProvaResponseDTO> provasRemoto = provasResponse.body!;
      List<Prova> provasBaixar = [];

      for (var provaRemoto in provasRemoto) {
        if (provaRemoto.isFinalizada()) {
          continue;
        }

        Prova? provaLocal = await sl.get<AppDatabase>().provaDao.obterPorIdNull(
              provaRemoto.id,
              provaRemoto.caderno,
            );

        // Prova nao esta localmente
        if (provaLocal == null) {
          provasBaixar.add(provaRemoto.toProvaModel());
        }

        // Verificando provas locais
        if (provaLocal != null && !provaLocal.isFinalizada()) {
          // Prova alterada
          if (!isSameDates(provaLocal.ultimaAlteracao, provaRemoto.ultimaAlteracao)) {
            info('[Prova ${provaLocal.id}] - Prova alterada - Baixando Novamente...');
            await DownloadManagerStore(provaId: provaLocal.id, caderno: provaLocal.caderno).removerDownloadCompleto();
            provasBaixar.add(provaRemoto.toProvaModel());
            continue;
          }

          // Prova não baixada
          if (provaLocal.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
            provasBaixar.add(provaRemoto.toProvaModel());
            continue;
          }
        }
      }

      info('Encontrado ${provasBaixar.length} provas para baixar em segundo plano');
      for (var provaBaixar in provasBaixar) {
        info('Prova ID: ${provaBaixar.id} - ${provaBaixar.caderno} - ${provaBaixar.descricao}');
      }

      for (var provaBaixar in provasBaixar) {
        info('Iniciando download prova ${provaBaixar.id} - ${provaBaixar.descricao}');
        await _saveProva(provaBaixar);

        DownloadManagerStore gerenciadorDownload = DownloadManagerStore(
          provaId: provaBaixar.id,
          caderno: provaBaixar.caderno,
        );

        await gerenciadorDownload.iniciarDownload();

        info('Download concluido');
      }
    } catch (e, stack) {
      await recordError(e, stack);
    }
  }

  _saveProva(Prova prova) async {
    await sl.get<AppDatabase>().provaDao.inserirOuAtualizar(prova);
  }
}
