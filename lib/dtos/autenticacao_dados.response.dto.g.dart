// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autenticacao_dados.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutenticacaoDadosResponseDTO _$AutenticacaoDadosResponseDTOFromJson(
        Map<String, dynamic> json) =>
    AutenticacaoDadosResponseDTO(
      json['nome'] as String,
      json['ano'] as String,
      json['tipoTurno'] as String,
      (json['tamanhoFonte'] as num).toDouble(),
      _$enumDecode(_$FonteTipoEnumEnumMap, json['familiaFonte']),
      _$enumDecode(_$ModalidadeEnumEnumMap, json['modalidade']),
      json['inicioTurno'] as int,
      json['fimTurno'] as int,
      json['dreAbreviacao'] as String,
      json['escola'] as String,
      json['turma'] as String,
      (json['deficiencias'] as List<dynamic>)
          .map((e) => _$enumDecode(_$DeficienciaEnumEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$AutenticacaoDadosResponseDTOToJson(
        AutenticacaoDadosResponseDTO instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'ano': instance.ano,
      'tipoTurno': instance.tipoTurno,
      'tamanhoFonte': instance.tamanhoFonte,
      'familiaFonte': _$FonteTipoEnumEnumMap[instance.familiaFonte],
      'modalidade': _$ModalidadeEnumEnumMap[instance.modalidade],
      'inicioTurno': instance.inicioTurno,
      'fimTurno': instance.fimTurno,
      'dreAbreviacao': instance.dreAbreviacao,
      'escola': instance.escola,
      'turma': instance.turma,
      'deficiencias': instance.deficiencias
          .map((e) => _$DeficienciaEnumEnumMap[e])
          .toList(),
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

const _$FonteTipoEnumEnumMap = {
  FonteTipoEnum.NAO_CADASTRADO: 0,
  FonteTipoEnum.POPPINS: 1,
  FonteTipoEnum.OPEN_DYSLEXIC: 2,
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

const _$DeficienciaEnumEnumMap = {
  DeficienciaEnum.NAO_CADASTRADO: 0,
  DeficienciaEnum.SUPERDOTACAO: 1,
  DeficienciaEnum.AUTISMO: 2,
  DeficienciaEnum.SURDEZ_LEVE_OU_MODERADA: 5,
  DeficienciaEnum.SURDEZ_SEVERA_OU_PROFUNDA: 6,
  DeficienciaEnum.DEFICIENCIA_INTELECTUAL: 8,
  DeficienciaEnum.DEFICIENCIA_MULTIPLA: 9,
  DeficienciaEnum.CEGUEIRA: 11,
  DeficienciaEnum.BAIXA_VISAO_OU_VISAO_SUBNORMAL: 12,
  DeficienciaEnum.SURDOCEGUEIRA: 14,
  DeficienciaEnum.NAO_POSSUI: 15,
  DeficienciaEnum.TRANST_DESINTEGRATIVO_INFANCIA: 16,
  DeficienciaEnum.SINDROME_DE_ASPERGER: 17,
  DeficienciaEnum.SINDROME_DE_RETT: 18,
  DeficienciaEnum.DEFICIENCIA_FISICA_NAO_CADEIRANTE: 19,
  DeficienciaEnum.DEFICIENCIA_FiSICA_CADEIRANTE: 20,
};
