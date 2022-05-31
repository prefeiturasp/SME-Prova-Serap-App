// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaResponseDTO _$ProvaResponseDTOFromJson(Map<String, dynamic> json) =>
    ProvaResponseDTO(
      id: json['id'] as int,
      descricao: json['descricao'] as String,
      itensQuantidade: json['itensQuantidade'] as int,
      dataInicio: DateTime.parse(json['dataInicio'] as String),
      dataFim: DateTime.parse(json['dataFim'] as String),
      status: _$enumDecode(_$EnumProvaStatusEnumMap, json['status']),
      senha: json['senha'] as String?,
      tempoExecucao: json['tempoExecucao'] as int,
      tempoExtra: json['tempoExtra'] as int,
      tempoAlerta: json['tempoAlerta'] as int,
      dataInicioProvaAluno: json['dataInicioProvaAluno'] == null
          ? null
          : DateTime.parse(json['dataInicioProvaAluno'] as String),
      dataFimProvaAluno: json['dataFimProvaAluno'] == null
          ? null
          : DateTime.parse(json['dataFimProvaAluno'] as String),
      modalidade: _$enumDecode(_$ModalidadeEnumEnumMap, json['modalidade']),
      quantidadeRespostaSincronizacao:
          json['quantidadeRespostaSincronizacao'] as int,
      ultimaAlteracao: DateTime.parse(json['ultimaAlteracao'] as String),
    );

Map<String, dynamic> _$ProvaResponseDTOToJson(ProvaResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'itensQuantidade': instance.itensQuantidade,
      'dataInicio': instance.dataInicio.toIso8601String(),
      'dataFim': instance.dataFim.toIso8601String(),
      'senha': instance.senha,
      'status': _$EnumProvaStatusEnumMap[instance.status],
      'tempoExecucao': instance.tempoExecucao,
      'tempoExtra': instance.tempoExtra,
      'tempoAlerta': instance.tempoAlerta,
      'dataInicioProvaAluno': instance.dataInicioProvaAluno?.toIso8601String(),
      'dataFimProvaAluno': instance.dataFimProvaAluno?.toIso8601String(),
      'modalidade': _$ModalidadeEnumEnumMap[instance.modalidade],
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

const _$EnumProvaStatusEnumMap = {
  EnumProvaStatus.NAO_INICIADA: 0,
  EnumProvaStatus.INICIADA: 1,
  EnumProvaStatus.FINALIZADA: 2,
  EnumProvaStatus.PENDENTE: 3,
  EnumProvaStatus.EM_REVISAO: 4,
  EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE: 5,
};

const _$ModalidadeEnumEnumMap = {
  ModalidadeEnum.NAO_CADASTRADO: 0,
  ModalidadeEnum.EI: 1,
  ModalidadeEnum.EJA: 3,
  ModalidadeEnum.CIEJA: 4,
  ModalidadeEnum.FUNDAMENTAL: 5,
  ModalidadeEnum.MEDIO: 6,
  ModalidadeEnum.CMCT: 7,
  ModalidadeEnum.MOVA: 8,
  ModalidadeEnum.ETEC: 9,
};
