// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_detalhes_alternativa.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaDetalhesAlternativaResponseDTO
    _$ProvaDetalhesAlternativaResponseDTOFromJson(Map<String, dynamic> json) =>
        ProvaDetalhesAlternativaResponseDTO(
          alternativaId: json['alternativaId'] as int,
          alternativaLegadoId: json['alternativaLegadoId'] as int,
          ordem: json['ordem'] as int,
        );

Map<String, dynamic> _$ProvaDetalhesAlternativaResponseDTOToJson(
        ProvaDetalhesAlternativaResponseDTO instance) =>
    <String, dynamic>{
      'alternativaId': instance.alternativaId,
      'alternativaLegadoId': instance.alternativaLegadoId,
      'ordem': instance.ordem,
    };
