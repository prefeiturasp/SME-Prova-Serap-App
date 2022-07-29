// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listagem_prova.admin.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListagemAdminProvaResponseDTO _$ListagemAdminProvaResponseDTOFromJson(
        Map<String, dynamic> json) =>
    ListagemAdminProvaResponseDTO(
      (json['items'] as List<dynamic>)
          .map((e) => AdminProvaResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['totalPaginas'] as int,
      json['totalRegistros'] as int,
    );

Map<String, dynamic> _$ListagemAdminProvaResponseDTOToJson(
        ListagemAdminProvaResponseDTO instance) =>
    <String, dynamic>{
      'items': instance.items,
      'totalPaginas': instance.totalPaginas,
      'totalRegistros': instance.totalRegistros,
    };
