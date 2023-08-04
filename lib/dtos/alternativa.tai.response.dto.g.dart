// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternativa.tai.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlternativaTaiResponseDTO _$AlternativaTaiResponseDTOFromJson(
        Map<String, dynamic> json) =>
    AlternativaTaiResponseDTO(
      id: json['id'] as int,
      descricao: json['descricao'] as String,
      ordem: json['ordem'] as int,
      numeracao: json['numeracao'] as String,
      questaoId: json['questaoId'] as int,
    );

Map<String, dynamic> _$AlternativaTaiResponseDTOToJson(
        AlternativaTaiResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'ordem': instance.ordem,
      'numeracao': instance.numeracao,
      'questaoId': instance.questaoId,
    };
