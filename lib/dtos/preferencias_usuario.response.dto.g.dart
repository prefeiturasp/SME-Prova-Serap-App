// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferencias_usuario.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreferenciasUsuarioResponseDTO _$PreferenciasUsuarioResponseDTOFromJson(
        Map<String, dynamic> json) =>
    PreferenciasUsuarioResponseDTO(
      (json['tamanhoFonte'] as num).toDouble(),
      $enumDecode(_$FonteTipoEnumEnumMap, json['familiaFonte']),
    );

Map<String, dynamic> _$PreferenciasUsuarioResponseDTOToJson(
        PreferenciasUsuarioResponseDTO instance) =>
    <String, dynamic>{
      'tamanhoFonte': instance.tamanhoFonte,
      'familiaFonte': _$FonteTipoEnumEnumMap[instance.familiaFonte]!,
    };

const _$FonteTipoEnumEnumMap = {
  FonteTipoEnum.NAO_CADASTRADO: 0,
  FonteTipoEnum.POPPINS: 1,
  FonteTipoEnum.OPEN_DYSLEXIC: 2,
};
