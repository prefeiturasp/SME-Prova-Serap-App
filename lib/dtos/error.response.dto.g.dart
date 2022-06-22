// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponseDTO _$ErrorResponseDTOFromJson(Map<String, dynamic> json) =>
    ErrorResponseDTO(
      mensagens:
          (json['mensagens'] as List<dynamic>).map((e) => e as String).toList(),
      existemErros: json['existemErros'] as bool,
    );

Map<String, dynamic> _$ErrorResponseDTOToJson(ErrorResponseDTO instance) =>
    <String, dynamic>{
      'mensagens': instance.mensagens,
      'existemErros': instance.existemErros,
    };
