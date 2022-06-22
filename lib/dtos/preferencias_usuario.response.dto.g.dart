// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferencias_usuario.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreferenciasUsuarioResponseDTO _$PreferenciasUsuarioResponseDTOFromJson(
        Map<String, dynamic> json) =>
    PreferenciasUsuarioResponseDTO(
      (json['tamanhoFonte'] as num).toDouble(),
      _$enumDecode(_$FonteTipoEnumEnumMap, json['familiaFonte']),
    );

Map<String, dynamic> _$PreferenciasUsuarioResponseDTOToJson(
        PreferenciasUsuarioResponseDTO instance) =>
    <String, dynamic>{
      'tamanhoFonte': instance.tamanhoFonte,
      'familiaFonte': _$FonteTipoEnumEnumMap[instance.familiaFonte],
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
