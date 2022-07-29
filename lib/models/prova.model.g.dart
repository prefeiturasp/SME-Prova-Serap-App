// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prova _$ProvaFromJson(Map<String, dynamic> json) => Prova(
      id: json['id'] as int,
      descricao: json['descricao'] as String,
      itensQuantidade: json['itensQuantidade'] as int,
      dataInicio: DateTime.parse(json['dataInicio'] as String),
      dataFim: json['dataFim'] == null
          ? null
          : DateTime.parse(json['dataFim'] as String),
      tempoExecucao: json['tempoExecucao'] as int,
      tempoExtra: json['tempoExtra'] as int,
      tempoAlerta: json['tempoAlerta'] as int?,
      downloadStatus: $enumDecodeNullable(
              _$EnumDownloadStatusEnumMap, json['downloadStatus']) ??
          EnumDownloadStatus.NAO_INICIADO,
      idDownload: json['idDownload'] as String?,
      status: $enumDecodeNullable(_$EnumProvaStatusEnumMap, json['status']) ??
          EnumProvaStatus.NAO_INICIADA,
      senha: json['senha'] as String?,
      dataInicioProvaAluno: json['dataInicioProvaAluno'] == null
          ? null
          : DateTime.parse(json['dataInicioProvaAluno'] as String),
      dataFimProvaAluno: json['dataFimProvaAluno'] == null
          ? null
          : DateTime.parse(json['dataFimProvaAluno'] as String),
      quantidadeRespostaSincronizacao:
          json['quantidadeRespostaSincronizacao'] as int,
      ultimaAlteracao: DateTime.parse(json['ultimaAlteracao'] as String),
      caderno: json['caderno'] as String,
    );

Map<String, dynamic> _$ProvaToJson(Prova instance) => <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'itensQuantidade': instance.itensQuantidade,
      'dataInicio': instance.dataInicio.toIso8601String(),
      'dataFim': instance.dataFim?.toIso8601String(),
      'tempoExecucao': instance.tempoExecucao,
      'tempoExtra': instance.tempoExtra,
      'tempoAlerta': instance.tempoAlerta,
      'dataInicioProvaAluno': instance.dataInicioProvaAluno?.toIso8601String(),
      'dataFimProvaAluno': instance.dataFimProvaAluno?.toIso8601String(),
      'downloadStatus': _$EnumDownloadStatusEnumMap[instance.downloadStatus]!,
      'idDownload': instance.idDownload,
      'status': _$EnumProvaStatusEnumMap[instance.status]!,
      'senha': instance.senha,
      'quantidadeRespostaSincronizacao':
          instance.quantidadeRespostaSincronizacao,
      'ultimaAlteracao': instance.ultimaAlteracao.toIso8601String(),
      'caderno': instance.caderno,
    };

const _$EnumDownloadStatusEnumMap = {
  EnumDownloadStatus.NAO_INICIADO: 0,
  EnumDownloadStatus.BAIXANDO: 1,
  EnumDownloadStatus.PAUSADO: 2,
  EnumDownloadStatus.CONCLUIDO: 3,
  EnumDownloadStatus.ERRO: 4,
  EnumDownloadStatus.ATUALIZAR: 5,
};

const _$EnumProvaStatusEnumMap = {
  EnumProvaStatus.NAO_INICIADA: 0,
  EnumProvaStatus.INICIADA: 1,
  EnumProvaStatus.FINALIZADA: 2,
  EnumProvaStatus.PENDENTE: 3,
  EnumProvaStatus.EM_REVISAO: 4,
  EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE: 5,
};
