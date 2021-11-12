import 'dart:convert';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:appserap/models/alternativa.model.dart';
import 'package:appserap/models/arquivo.model.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/questao.model.dart';

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

  EnumProvaStatus status;

  String? senha;

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
    this.status = EnumProvaStatus.NAO_INICIADA,
    this.senha,
    this.dataInicioProvaAluno,
    this.dataFimProvaAluno,
  });

  factory Prova.fromJson(Map<String, dynamic> json) => _$ProvaFromJson(json);
  Map<String, dynamic> toJson() => _$ProvaToJson(this);

  static Future<Prova?> carregaProvaCache(int idProva) async {
    AppDatabase db = GetIt.I.get();

    ProvaDb? provaDb = await db.obterProvaPorIdNull(idProva);

    if (provaDb != null) {
      var prova = Prova(
        id: provaDb.id,
        downloadStatus: EnumDownloadStatus.values.firstWhere((element) => element.index == provaDb.downloadStatus),
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
      );

      var questoesDb = await db.obterQuestoesPorProvaId(prova.id);
      prova.questoes = questoesDb
          .map(
            (e) => Questao(
              id: e.id,
              titulo: e.titulo,
              descricao: e.descricao,
              ordem: e.ordem,
              alternativas: [],
              arquivos: [],
              tipo: EnumTipoQuestao.values.firstWhere((element) => element.index == e.tipo),
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
                id: e.id,
                caminho: e.caminho,
                base64: e.base64,
                questaoId: e.questaoId,
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
      downloadStatus: EnumDownloadStatus.values.firstWhere((element) => element.index == provaDb.downloadStatus),
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
    );

    return prova;
  }

  static salvaProvaCache(Prova prova) async {
    AppDatabase db = GetIt.I.get();
    await db.inserirOuAtualizarProva(
      ProvaDb(
        id: prova.id,
        descricao: prova.descricao,
        downloadStatus: prova.downloadStatus.index,
        tempoExtra: prova.tempoExtra,
        tempoExecucao: prova.tempoExecucao,
        tempoAlerta: prova.tempoAlerta,
        itensQuantidade: prova.itensQuantidade,
        status: prova.status.index,
        dataInicio: prova.dataInicio,
        ultimaAtualizacao: DateTime.now(),
        dataFim: prova.dataFim,
        dataInicioProvaAluno: prova.dataInicioProvaAluno,
        dataFimProvaAluno: prova.dataFimProvaAluno,

      ),
    );
  }

  @override
  String toString() {
    return 'Prova(id: $id, descricao: $descricao, itensQuantidade: $itensQuantidade, dataInicio: $dataInicio, dataFim: $dataFim, tempoExecucao: $tempoExecucao, tempoExtra: $tempoExtra, tempoAlerta: $tempoAlerta, dataInicioProvaAluno: $dataInicioProvaAluno, dataFimProvaAluno: $dataFimProvaAluno, questoes: $questoes, downloadStatus: $downloadStatus, downloadProgresso: $downloadProgresso, status: $status)';
  }
}
