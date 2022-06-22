// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternativa.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlternativaResponseDTO _$AlternativaResponseDTOFromJson(
        Map<String, dynamic> json) =>
    AlternativaResponseDTO(
      id: json['id'] as int,
      descricao: json['descricao'] as String,
      ordem: json['ordem'] as int,
      numeracao: json['numeracao'] as String,
      questaoId: json['questaoId'] as int,
    );

Map<String, dynamic> _$AlternativaResponseDTOToJson(
        AlternativaResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'ordem': instance.ordem,
      'numeracao': instance.numeracao,
      'questaoId': instance.questaoId,
    };
