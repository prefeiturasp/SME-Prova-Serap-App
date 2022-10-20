// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_detalhes_caderno_questao.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaDetalhesCadernoQuestaoResponseDTO
    _$ProvaDetalhesCadernoQuestaoResponseDTOFromJson(
            Map<String, dynamic> json) =>
        ProvaDetalhesCadernoQuestaoResponseDTO(
          questaoId: json['questaoId'] as int,
          questaoLegadoId: json['questaoLegadoId'] as int,
          ordem: json['ordem'] as int,
        );

Map<String, dynamic> _$ProvaDetalhesCadernoQuestaoResponseDTOToJson(
        ProvaDetalhesCadernoQuestaoResponseDTO instance) =>
    <String, dynamic>{
      'questaoId': instance.questaoId,
      'questaoLegadoId': instance.questaoLegadoId,
      'ordem': instance.ordem,
    };
