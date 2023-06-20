// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_resultado_resumo.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaResultadoResumoResponseDto _$ProvaResultadoResumoResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ProvaResultadoResumoResponseDto(
      resumos: (json['resumos'] as List<dynamic>)
          .map((e) => ProvaResultadoResumoQuestaoResponseDto.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      proficiencia: (json['proficiencia'] as num).toDouble(),
    );

Map<String, dynamic> _$ProvaResultadoResumoResponseDtoToJson(
        ProvaResultadoResumoResponseDto instance) =>
    <String, dynamic>{
      'resumos': instance.resumos,
      'proficiencia': instance.proficiencia,
    };
