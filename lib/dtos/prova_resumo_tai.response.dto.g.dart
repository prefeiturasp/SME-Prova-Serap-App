// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_resumo_tai.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaResumoTaiResponseDto _$ProvaResumoTaiResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ProvaResumoTaiResponseDto(
      ordemQuestao: json['ordemQuestao'] as int,
      descricaoQuestao: json['descricaoQuestao'] as String,
      alternativaAluno: json['alternativaAluno'] as String,
    );

Map<String, dynamic> _$ProvaResumoTaiResponseDtoToJson(
        ProvaResumoTaiResponseDto instance) =>
    <String, dynamic>{
      'ordemQuestao': instance.ordemQuestao,
      'descricaoQuestao': instance.descricaoQuestao,
      'alternativaAluno': instance.alternativaAluno,
    };
