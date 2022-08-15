// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_caderno.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaCaderno _$ProvaCadernoFromJson(Map<String, dynamic> json) => ProvaCaderno(
      provaId: json['provaId'] as int,
      caderno: json['caderno'] as String,
      ordem: json['ordem'] as int,
      questaoId: json['questaoId'] as int,
      questaoLegadoId: json['questaoLegadoId'] as int,
    );

Map<String, dynamic> _$ProvaCadernoToJson(ProvaCaderno instance) =>
    <String, dynamic>{
      'provaId': instance.provaId,
      'caderno': instance.caderno,
      'questaoId': instance.questaoId,
      'questaoLegadoId': instance.questaoLegadoId,
      'ordem': instance.ordem,
    };
