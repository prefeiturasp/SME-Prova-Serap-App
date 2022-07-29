// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_prova_caderno.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminProvaCadernoResponseDTO _$AdminProvaCadernoResponseDTOFromJson(
        Map<String, dynamic> json) =>
    AdminProvaCadernoResponseDTO(
      cadernos:
          (json['cadernos'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AdminProvaCadernoResponseDTOToJson(
        AdminProvaCadernoResponseDTO instance) =>
    <String, dynamic>{
      'cadernos': instance.cadernos,
    };
