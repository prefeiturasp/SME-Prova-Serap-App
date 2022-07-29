// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_detalhes.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaDetalhesResponseDTO _$ProvaDetalhesResponseDTOFromJson(
        Map<String, dynamic> json) =>
    ProvaDetalhesResponseDTO(
      provaId: json['provaId'] as int,
      questoesIds:
          (json['questoesIds'] as List<dynamic>).map((e) => e as int).toList(),
      contextosProvaIds: (json['contextosProvaIds'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$ProvaDetalhesResponseDTOToJson(
        ProvaDetalhesResponseDTO instance) =>
    <String, dynamic>{
      'provaId': instance.provaId,
      'questoesIds': instance.questoesIds,
      'contextosProvaIds': instance.contextosProvaIds,
    };
