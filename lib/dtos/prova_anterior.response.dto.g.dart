// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_anterior.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaAnteriorResponseDTO _$ProvaAnteriorResponseDTOFromJson(
        Map<String, dynamic> json) =>
    ProvaAnteriorResponseDTO(
      id: json['id'] as int,
      descricao: json['descricao'] as String,
      itensQuantidade: json['itensQuantidade'] as int,
      dataInicio: DateTime.parse(json['dataInicio'] as String),
      dataFim: json['dataFim'] == null
          ? null
          : DateTime.parse(json['dataFim'] as String),
      tempoTotal: json['tempoTotal'] as int,
      status: $enumDecode(_$EnumProvaStatusEnumMap, json['status']),
      dataInicioProvaAluno: json['dataInicioProvaAluno'] == null
          ? null
          : DateTime.parse(json['dataInicioProvaAluno'] as String),
      dataFimProvaAluno: json['dataFimProvaAluno'] == null
          ? null
          : DateTime.parse(json['dataFimProvaAluno'] as String),
    );

Map<String, dynamic> _$ProvaAnteriorResponseDTOToJson(
        ProvaAnteriorResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'itensQuantidade': instance.itensQuantidade,
      'dataInicio': instance.dataInicio.toIso8601String(),
      'dataFim': instance.dataFim?.toIso8601String(),
      'tempoTotal': instance.tempoTotal,
      'status': _$EnumProvaStatusEnumMap[instance.status]!,
      'dataInicioProvaAluno': instance.dataInicioProvaAluno?.toIso8601String(),
      'dataFimProvaAluno': instance.dataFimProvaAluno?.toIso8601String(),
    };

const _$EnumProvaStatusEnumMap = {
  EnumProvaStatus.NAO_INICIADA: 0,
  EnumProvaStatus.INICIADA: 1,
  EnumProvaStatus.FINALIZADA: 2,
  EnumProvaStatus.PENDENTE: 3,
  EnumProvaStatus.EM_REVISAO: 4,
  EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE: 5,
};
