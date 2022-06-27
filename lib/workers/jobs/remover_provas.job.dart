import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/interfaces/job_config.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/managers/download.manager.store.dart';
import 'package:appserap/models/prova.model.dart';

class RemoverProvasJob with Job, Loggable, Database {
  @override
  JobConfig configuration() {
    return JobConfig(
      frequency: Duration(days: 1),
      taskName: 'RemocaoProvasExpiradas',
      uniqueName: 'provas-remocao-expiradas',
    );
  }

  @override
  run() async {
    List<Prova> provas = await db.provaDao.getProvasExpiradas();

    info('Removendo ${provas.length} provas expiradas');

    for (var prova in provas) {
      try {
        var downloadManager = DownloadManagerStore(provaId: prova.id);
        await downloadManager.deleteDownload();
      } catch (e, stacktrace) {
        severe(e);
        severe(stacktrace);
      }
    }
  }
}
