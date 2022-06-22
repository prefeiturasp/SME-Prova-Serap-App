// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autenticacao.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutenticacaoResponseDTO _$AutenticacaoResponseDTOFromJson(
        Map<String, dynamic> json) =>
    AutenticacaoResponseDTO(
      token: json['token'] as String,
      dataHoraExpiracao: DateTime.parse(json['dataHoraExpiracao'] as String),
      ultimoLogin: json['ultimoLogin'] == null
          ? null
          : DateTime.parse(json['ultimoLogin'] as String),
    );

Map<String, dynamic> _$AutenticacaoResponseDTOToJson(
        AutenticacaoResponseDTO instance) =>
    <String, dynamic>{
      'token': instance.token,
      'dataHoraExpiracao': instance.dataHoraExpiracao.toIso8601String(),
      'ultimoLogin': instance.ultimoLogin?.toIso8601String(),
    };
