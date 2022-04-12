import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/posicionamento_imagem.enum.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:appserap/models/contexto_prova.model.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/questao.model.dart';

import 'arquivo_audio.model.dart';
import 'arquivo_video.model.dart';

part 'prova.model.g.dart';

@JsonSerializable()
class Prova {
  int id;
  String descricao;
  int itensQuantidade;
  DateTime dataInicio;
  DateTime? dataFim;

  int tempoExecucao;
  int tempoExtra;
  int? tempoAlerta;

  DateTime? dataInicioProvaAluno;
  DateTime? dataFimProvaAluno;

  List<Questao> questoes;

  EnumDownloadStatus downloadStatus;
  double downloadProgresso;
  int? idDownload;

  EnumProvaStatus status;

  String? senha;

  List<ContextoProva>? contextosProva;

  Prova({
    required this.id,
    required this.descricao,
    required this.itensQuantidade,
    required this.dataInicio,
    this.dataFim,
    required this.tempoExecucao,
    required this.tempoExtra,
    required this.tempoAlerta,
    required this.questoes,
    this.downloadStatus = EnumDownloadStatus.NAO_INICIADO,
    this.downloadProgresso = 0,
    this.idDownload,
    this.status = EnumProvaStatus.NAO_INICIADA,
    this.senha,
    this.dataInicioProvaAluno,
    this.dataFimProvaAluno,
    this.contextosProva,
  });

  bool isFinalizada() {
    return status == EnumProvaStatus.FINALIZADA || status == EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE;
  }

  factory Prova.fromJson(Map<String, dynamic> json) => _$ProvaFromJson(json);
  Map<String, dynamic> toJson() => _$ProvaToJson(this);

  static Future<Prova?> carregaProvaCache(int idProva) async {
    AppDatabase db = GetIt.I.get();

    ProvaDb? provaDb = await db.obterProvaPorIdNull(idProva);

    if (provaDb != null) {
      var prova = Prova(
        id: provaDb.id,
        downloadStatus: EnumDownloadStatus.values.firstWhere((element) => element == provaDb.downloadStatus),
        itensQuantidade: provaDb.itensQuantidade,
        tempoAlerta: provaDb.tempoAlerta,
        tempoExecucao: provaDb.tempoExecucao,
        descricao: provaDb.descricao,
        tempoExtra: provaDb.tempoExtra,
        dataInicio: provaDb.dataInicio,
        dataFim: provaDb.dataFim,
        dataInicioProvaAluno: provaDb.dataInicioProvaAluno,
        dataFimProvaAluno: provaDb.dataFimProvaAluno,
        questoes: [],
        status: EnumProvaStatus.values[provaDb.status],
        senha: provaDb.senha,
        idDownload: provaDb.idDownload,
      );

      var contextosProvaDb = await db.obterContextoPorProvaId(prova.id);

      if (contextosProvaDb.isNotEmpty) {
        prova.contextosProva = contextosProvaDb
            .map((e) => ContextoProva(
                  id: e.id,
                  provaId: e.provaId,
                  imagem: e.imagem,
                  imagemBase64: e.imagemBase64,
                  posicionamento: PosicionamentoImagemEnum.values.firstWhere((element) => element == e.posicionamento),
                  ordem: e.ordem,
                  titulo: e.titulo,
                  texto: e.texto,
                ))
            .toList();
      }

      var questoesDb = await db.questaoDAO.obterPorProvaId(prova.id);
      prova.questoes = questoesDb
          .map(
            (e) => Questao(
              id: e.id,
              titulo: e.titulo,
              descricao: e.descricao,
              ordem: e.ordem,
              alternativas: [],
              arquivos: [],
              arquivosVideos: [],
              arquivosAudio: [],
              tipo: EnumTipoQuestao.values.firstWhere((element) => element == e.tipo),
              quantidadeAlternativas: e.quantidadeAlternativas!,
            ),
          )
          .toList();

      for (var questao in prova.questoes) {
        var alternativasDb = await db.obterAlternativasPorQuestaoId(questao.id);
        questao.alternativas = alternativasDb
            .map(
              (e) => Alternativa(
                  numeracao: e.numeracao, descricao: e.descricao, id: e.id, ordem: e.ordem, questaoId: e.questaoId),
            )
            .toList();

        var arquivosDb = await db.obterArquivosPorQuestaoId(questao.id);
        questao.arquivos = arquivosDb
            .map(
              (e) => Arquivo(
                id: e.legadoId!,
                caminho: e.caminho,
                base64: e.base64,
                questaoId: e.questaoId,
              ),
            )
            .toList();

        var arquivosVideosDb = await db.arquivosVideosDao.obterPorQuestaoId(questao.id);
        questao.arquivosVideos = arquivosVideosDb
            .map(
              (e) => ArquivoVideo(
                id: e.id,
                path: e.path,
                idProva: e.provaId,
                idQuestao: e.questaoId,
              ),
            )
            .toList();

        var arquivosAudiosDb = await db.arquivosAudioDao.obterPorQuestaoId(questao.id);
        questao.arquivosAudio = arquivosAudiosDb
            .map(
              (e) => ArquivoAudio(
                id: e.id,
                path: e.path,
                idProva: e.provaId,
                idQuestao: e.questaoId,
              ),
            )
            .toList();
      }

      return prova;
    }
  }

  static Prova fromProvaDb(ProvaDb provaDb) {
    Prova prova = Prova(
      id: provaDb.id,
      downloadStatus: EnumDownloadStatus.values.firstWhere((element) => element == provaDb.downloadStatus),
      itensQuantidade: provaDb.itensQuantidade,
      tempoAlerta: provaDb.tempoAlerta,
      tempoExecucao: provaDb.tempoExecucao,
      descricao: provaDb.descricao,
      tempoExtra: provaDb.tempoExtra,
      dataInicio: provaDb.dataInicio,
      dataFim: provaDb.dataFim,
      dataInicioProvaAluno: provaDb.dataInicioProvaAluno,
      dataFimProvaAluno: provaDb.dataFimProvaAluno,
      questoes: [],
      status: EnumProvaStatus.values[provaDb.status],
      senha: provaDb.senha,
      idDownload: provaDb.idDownload,
    );

    return prova;
  }

  static salvaProvaCache(Prova prova) async {
    AppDatabase db = GetIt.I.get();

    await db.inserirOuAtualizarProva(
      ProvaDb(
        id: prova.id,
        descricao: prova.descricao,
        downloadStatus: prova.downloadStatus,
        tempoExtra: prova.tempoExtra,
        tempoExecucao: prova.tempoExecucao,
        tempoAlerta: prova.tempoAlerta,
        itensQuantidade: prova.itensQuantidade,
        status: prova.status.index,
        dataInicio: prova.dataInicio,
        ultimaAtualizacao: DateTime.now(),
        dataFim: prova.dataFim,
        dataFimProvaAluno: prova.dataFimProvaAluno,
        dataInicioProvaAluno: prova.dataInicioProvaAluno,
        senha: prova.senha,
        idDownload: prova.idDownload,
      ),
    );
  }

  @override
  String toString() {
    return 'Prova(id: $id, descricao: $descricao, itensQuantidade: $itensQuantidade, dataInicio: $dataInicio, dataFim: $dataFim, tempoExecucao: $tempoExecucao, tempoExtra: $tempoExtra, tempoAlerta: $tempoAlerta, dataInicioProvaAluno: $dataInicioProvaAluno, dataFimProvaAluno: $dataFimProvaAluno, questoes: $questoes, downloadStatus: $downloadStatus, downloadProgresso: $downloadProgresso, status: $status)';
  }
}
