// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_resposta.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestaoRespostaResponseDTO _$QuestaoRespostaResponseDTOFromJson(
        Map<String, dynamic> json) =>
    QuestaoRespostaResponseDTO(
      questaoId: json['questaoId'] as int,
      alternativaId: json['alternativaId'] as int?,
      resposta: json['resposta'] as String?,
      dataHoraResposta: DateTime.parse(json['dataHoraResposta'] as String),
    );

Map<String, dynamic> _$QuestaoRespostaResponseDTOToJson(
        QuestaoRespostaResponseDTO instance) =>
    <String, dynamic>{
      'alternativaId': instance.alternativaId,
      'resposta': instance.resposta,
      'dataHoraResposta': instance.dataHoraResposta.toIso8601String(),
      'questaoId': instance.questaoId,
    };
