// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova_resumo.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminProvaResumoResponseDTO _$AdminProvaResumoResponseDTOFromJson(
        Map<String, dynamic> json) =>
    AdminProvaResumoResponseDTO(
      id: json['id'] as int,
      titulo: json['titulo'] as String?,
      descricao: json['descricao'] as String?,
      caderno: json['caderno'] as String,
      ordem: json['ordem'] as int,
    );

Map<String, dynamic> _$AdminProvaResumoResponseDTOToJson(
        AdminProvaResumoResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'caderno': instance.caderno,
      'ordem': instance.ordem,
    };
