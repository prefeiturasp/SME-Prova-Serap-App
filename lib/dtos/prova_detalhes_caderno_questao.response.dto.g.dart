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
          alternativas: (json['alternativas'] as List<dynamic>)
              .map((e) => ProvaDetalhesAlternativaResponseDTO.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$ProvaDetalhesCadernoQuestaoResponseDTOToJson(
        ProvaDetalhesCadernoQuestaoResponseDTO instance) =>
    <String, dynamic>{
      'questaoId': instance.questaoId,
      'questaoLegadoId': instance.questaoLegadoId,
      'ordem': instance.ordem,
      'alternativas': instance.alternativas,
    };
