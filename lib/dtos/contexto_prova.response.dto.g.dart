// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contexto_prova.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContextoProvaResponseDTO _$ContextoProvaResponseDTOFromJson(
        Map<String, dynamic> json) =>
    ContextoProvaResponseDTO(
      id: json['id'] as int,
      provaId: json['provaId'] as int,
      imagem: json['imagem'] as String?,
      posicionamento: _$enumDecode(
          _$PosicionamentoImagemEnumEnumMap, json['posicionamento']),
      ordem: json['ordem'] as int,
      titulo: json['titulo'] as String?,
      texto: json['texto'] as String?,
    );

Map<String, dynamic> _$ContextoProvaResponseDTOToJson(
        ContextoProvaResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provaId': instance.provaId,
      'imagem': instance.imagem,
      'posicionamento':
          _$PosicionamentoImagemEnumEnumMap[instance.posicionamento],
      'ordem': instance.ordem,
      'titulo': instance.titulo,
      'texto': instance.texto,
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

const _$PosicionamentoImagemEnumEnumMap = {
  PosicionamentoImagemEnum.NAO_CADASTRADO: 0,
  PosicionamentoImagemEnum.DIREITA: 1,
  PosicionamentoImagemEnum.CENTRO: 2,
  PosicionamentoImagemEnum.ESQUERDA: 3,
};
