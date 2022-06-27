import 'package:appserap/interfaces/database.interface.dart';
import 'package:appserap/interfaces/job.interface.dart';
import 'package:appserap/interfaces/job_config.interface.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/utils/universal/universal.util.dart';

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
        await removerConteudoProva(prova);
      } catch (e, stacktrace) {
        severe(e);
        severe(stacktrace);
      }
    }
  }

  removerConteudoProva(Prova prova) async {
    await removerContexto(prova);
    await removerQuestoes(prova);
    await removerAlternativas(prova);
    await removerArquivosImagem(prova);
    await removerArquivosAudio(prova);
    await removerArquivosVideo(prova);
    await removerCacheAluno(prova);
    await removerProva(prova);
  }

  removerContexto(Prova prova) async {
    int total = await db.contextoProvaDao.removerPorProvaId(prova.id);
    info("[Prova ${prova.id} - Removido $total contextos");
  }

  removerQuestoes(Prova prova) async {
    int total = await db.questaoDao.removerPorProvaId(prova.id);
    info("[Prova ${prova.id} - Removido $total questoes");
  }

  removerAlternativas(Prova prova) async {
    int total = await db.alternativaDao.removerPorProvaId(prova.id);
    info("[Prova ${prova.id} - Removido $total alternativas");
  }

  removerArquivosImagem(Prova prova) async {
    var arquivos = await db.arquivoDao.findByProvaId(prova.id);

    for (var arquivo in arquivos) {
      await db.arquivoDao.remover(arquivo);
      await apagarArquivo(arquivo.caminho);
    }

    info("[Prova ${prova.id} - Removido ${arquivos.length} arquivos de imagem");
  }

  removerArquivosAudio(Prova prova) async {
    var arquivos = await db.arquivosAudioDao.findByProvaId(prova.id);

    for (var arquivo in arquivos) {
      await db.arquivosAudioDao.remover(arquivo);
      await apagarArquivo(arquivo.path);
    }

    info("[Prova ${prova.id} - Removido ${arquivos.length} arquivos de audio");
  }

  removerArquivosVideo(Prova prova) async {
    var arquivos = await db.arquivosVideosDao.findByProvaId(prova.id);

    for (var arquivo in arquivos) {
      await db.arquivosVideosDao.remover(arquivo);
      await apagarArquivo(arquivo.path);
    }

    info("[Prova ${prova.id} - Removido ${arquivos.length} arquivos de video");
  }

  removerCacheAluno(Prova prova) async {
    int total = await db.provaAlunoDao.removerPorProvaId(prova.id);
    info("[Prova ${prova.id} - Removido $total caches de provas");
  }

  removerProva(Prova prova) async {
    await db.provaDao.deleteByProva(prova.id);
  }
}
