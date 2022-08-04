// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_detalhes_caderno.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaDetalhesCadernoResponseDTO _$ProvaDetalhesCadernoResponseDTOFromJson(
        Map<String, dynamic> json) =>
    ProvaDetalhesCadernoResponseDTO(
      provaId: json['provaId'] as int,
      questoes: (json['questoes'] as List<dynamic>)
          .map((e) => ProvaDetalhesCadernoQuestaoResponseDTO.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      contextosProvaIds: (json['contextosProvaIds'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$ProvaDetalhesCadernoResponseDTOToJson(
        ProvaDetalhesCadernoResponseDTO instance) =>
    <String, dynamic>{
      'provaId': instance.provaId,
      'questoes': instance.questoes,
      'contextosProvaIds': instance.contextosProvaIds,
    };
