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
      questoes: (json['questoes'] as List<dynamic>)
          .map((e) => Questao.fromJson(e as Map<String, dynamic>))
          .toList(),
      downloadStatus: _$enumDecodeNullable(
              _$EnumDownloadStatusEnumMap, json['downloadStatus']) ??
          EnumDownloadStatus.NAO_INICIADO,
      downloadProgresso: (json['downloadProgresso'] as num?)?.toDouble() ?? 0,
      idDownload: json['idDownload'] as String?,
      status: _$enumDecodeNullable(_$EnumProvaStatusEnumMap, json['status']) ??
          EnumProvaStatus.NAO_INICIADA,
      senha: json['senha'] as String?,
      dataInicioProvaAluno: json['dataInicioProvaAluno'] == null
          ? null
          : DateTime.parse(json['dataInicioProvaAluno'] as String),
      dataFimProvaAluno: json['dataFimProvaAluno'] == null
          ? null
          : DateTime.parse(json['dataFimProvaAluno'] as String),
      contextosProva: (json['contextosProva'] as List<dynamic>?)
          ?.map((e) => ContextoProva.fromJson(e as Map<String, dynamic>))
          .toList(),
      quantidadeRespostaSincronizacao:
          json['quantidadeRespostaSincronizacao'] as int,
      ultimaAlteracao: DateTime.parse(json['ultimaAlteracao'] as String),
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
      'questoes': instance.questoes,
      'downloadStatus': _$EnumDownloadStatusEnumMap[instance.downloadStatus],
      'downloadProgresso': instance.downloadProgresso,
      'idDownload': instance.idDownload,
      'status': _$EnumProvaStatusEnumMap[instance.status],
      'senha': instance.senha,
      'contextosProva': instance.contextosProva,
      'quantidadeRespostaSincronizacao':
          instance.quantidadeRespostaSincronizacao,
      'ultimaAlteracao': instance.ultimaAlteracao.toIso8601String(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$EnumDownloadStatusEnumMap = {
  EnumDownloadStatus.NAO_INICIADO: 0,
  EnumDownloadStatus.BAIXANDO: 1,
  EnumDownloadStatus.PAUSADO: 2,
  EnumDownloadStatus.CONCLUIDO: 3,
  EnumDownloadStatus.ERRO: 4,
};

const _$EnumProvaStatusEnumMap = {
  EnumProvaStatus.NAO_INICIADA: 0,
  EnumProvaStatus.INICIADA: 1,
  EnumProvaStatus.FINALIZADA: 2,
  EnumProvaStatus.PENDENTE: 3,
  EnumProvaStatus.EM_REVISAO: 4,
  EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE: 5,
};
