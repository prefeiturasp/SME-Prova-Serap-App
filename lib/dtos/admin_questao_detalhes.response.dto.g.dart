// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_questao_detalhes.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminQuestaoDetalhesResponseDTO _$AdminQuestaoDetalhesResponseDTOFromJson(
        Map<String, dynamic> json) =>
    AdminQuestaoDetalhesResponseDTO(
      provaId: json['provaId'] as int,
      questaoId: json['questaoId'] as int,
      arquivosId:
          (json['arquivosId'] as List<dynamic>).map((e) => e as int).toList(),
      alternativasId: (json['alternativasId'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      audiosId:
          (json['audiosId'] as List<dynamic>).map((e) => e as int).toList(),
      videosId:
          (json['videosId'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$AdminQuestaoDetalhesResponseDTOToJson(
        AdminQuestaoDetalhesResponseDTO instance) =>
    <String, dynamic>{
      'provaId': instance.provaId,
      'questaoId': instance.questaoId,
      'arquivosId': instance.arquivosId,
      'alternativasId': instance.alternativasId,
      'audiosId': instance.audiosId,
      'videosId': instance.videosId,
    };
