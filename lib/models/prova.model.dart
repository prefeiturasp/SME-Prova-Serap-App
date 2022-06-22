import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';

part 'prova.model.g.dart';

@JsonSerializable()
class Prova implements Insertable<Prova> {
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

  EnumDownloadStatus downloadStatus;
  String? idDownload;

  EnumProvaStatus status;

  String? senha;

  int quantidadeRespostaSincronizacao;
  DateTime ultimaAlteracao;

  Prova({
    required this.id,
    required this.descricao,
    required this.itensQuantidade,
    required this.dataInicio,
    this.dataFim,
    required this.tempoExecucao,
    required this.tempoExtra,
    required this.tempoAlerta,
    this.downloadStatus = EnumDownloadStatus.NAO_INICIADO,
    this.idDownload,
    this.status = EnumProvaStatus.NAO_INICIADA,
    this.senha,
    this.dataInicioProvaAluno,
    this.dataFimProvaAluno,
    required this.quantidadeRespostaSincronizacao,
    required this.ultimaAlteracao,
  });

  bool isFinalizada() {
    return status == EnumProvaStatus.FINALIZADA || status == EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE;
  }

  factory Prova.fromJson(Map<String, dynamic> json) => _$ProvaFromJson(json);
  Map<String, dynamic> toJson() => _$ProvaToJson(this);

  @override
  String toString() {
    return 'Prova(id: $id, descricao: $descricao, itensQuantidade: $itensQuantidade, dataInicio: $dataInicio, dataFim: $dataFim, tempoExecucao: $tempoExecucao, tempoExtra: $tempoExtra, tempoAlerta: $tempoAlerta, dataInicioProvaAluno: $dataInicioProvaAluno, dataFimProvaAluno: $dataFimProvaAluno, downloadStatus: $downloadStatus, status: $status)';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ProvasDbCompanion(
      id: Value(id),
      descricao: Value(descricao),
      downloadStatus: Value(downloadStatus),
      tempoExtra: Value(tempoExtra),
      tempoExecucao: Value(tempoExecucao),
      tempoAlerta: Value(tempoAlerta),
      itensQuantidade: Value(itensQuantidade),
      status: Value(status),
      dataInicio: Value(dataInicio),
      ultimaAtualizacao: Value(ultimaAlteracao),
      dataFim: Value(dataFim),
      dataFimProvaAluno: Value(dataFimProvaAluno),
      dataInicioProvaAluno: Value(dataInicioProvaAluno),
      senha: Value(senha),
      idDownload: Value(idDownload),
      quantidadeRespostaSincronizacao: Value(quantidadeRespostaSincronizacao),
      ultimaAlteracao: Value(ultimaAlteracao),
    ).toColumns(nullToAbsent);
  }
}
