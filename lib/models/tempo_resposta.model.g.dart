// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tempo_resposta.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TempoResposta _$TempoRespostaFromJson(Map<String, dynamic> json) =>
    TempoResposta(
      questaoId: json['questaoId'] as int,
      tempo: json['tempo'] as int?,
    );

Map<String, dynamic> _$TempoRespostaToJson(TempoResposta instance) =>
    <String, dynamic>{
      'questaoId': instance.questaoId,
      'tempo': instance.tempo,
    };
