// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_completa_resposta.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestaoCompletaRespostaResponseDto _$QuestaoCompletaRespostaResponseDtoFromJson(
        Map<String, dynamic> json) =>
    QuestaoCompletaRespostaResponseDto(
      questao: QuestaoCompletaResponseDTO.fromJson(
          json['questao'] as Map<String, dynamic>),
      ordemAlternativaCorreta: json['ordemAlternativaCorreta'] as int?,
      ordemAlternativaResposta: json['ordemAlternativaResposta'] as int?,
    )..respostaConstruida = json['respostaConstruida'] as String?;

Map<String, dynamic> _$QuestaoCompletaRespostaResponseDtoToJson(
        QuestaoCompletaRespostaResponseDto instance) =>
    <String, dynamic>{
      'questao': instance.questao,
      'ordemAlternativaCorreta': instance.ordemAlternativaCorreta,
      'ordemAlternativaResposta': instance.ordemAlternativaResposta,
      'respostaConstruida': instance.respostaConstruida,
    };
