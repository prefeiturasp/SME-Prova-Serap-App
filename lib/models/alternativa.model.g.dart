// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternativa.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alternativa _$AlternativaFromJson(Map<String, dynamic> json) => Alternativa(
      id: json['id'] as int,
      provaId: json['provaId'] as int,
      questaoId: json['questaoId'] as int,
      descricao: json['descricao'] as String,
      ordem: json['ordem'] as int,
      numeracao: json['numeracao'] as String,
    );

Map<String, dynamic> _$AlternativaToJson(Alternativa instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provaId': instance.provaId,
      'questaoId': instance.questaoId,
      'descricao': instance.descricao,
      'ordem': instance.ordem,
      'numeracao': instance.numeracao,
    };
