// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternativa.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alternativa _$AlternativaFromJson(Map<String, dynamic> json) => Alternativa(
      id: json['id'] as int,
      questaoLegadoId: json['questaoLegadoId'] as int,
      descricao: json['descricao'] as String,
      ordem: json['ordem'] as int,
      numeracao: json['numeracao'] as String,
    );

Map<String, dynamic> _$AlternativaToJson(Alternativa instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questaoLegadoId': instance.questaoLegadoId,
      'descricao': instance.descricao,
      'ordem': instance.ordem,
      'numeracao': instance.numeracao,
    };
