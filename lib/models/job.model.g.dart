// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      id: json['id'] as String,
      nome: json['nome'] as String,
      statusUltimaExecucao: $enumDecodeNullable(
          _$EnumJobStatusEnumMap, json['statusUltimaExecucao']),
      ultimaExecucao: json['ultimaExecucao'] == null
          ? null
          : DateTime.parse(json['ultimaExecucao'] as String),
      intervalo: json['intervalo'] as int,
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'statusUltimaExecucao':
          _$EnumJobStatusEnumMap[instance.statusUltimaExecucao],
      'ultimaExecucao': instance.ultimaExecucao?.toIso8601String(),
      'intervalo': instance.intervalo,
    };

const _$EnumJobStatusEnumMap = {
  EnumJobStatus.COMPLETADO: 'COMPLETADO',
  EnumJobStatus.PARADO: 'PARADO',
  EnumJobStatus.EXECUTANDO: 'EXECUTANDO',
  EnumJobStatus.ERRO: 'ERRO',
};
