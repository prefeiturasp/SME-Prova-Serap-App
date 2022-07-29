// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autenticacao.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutenticacaoDTO _$AutenticacaoDTOFromJson(Map<String, dynamic> json) =>
    AutenticacaoDTO(
      json['login'] as String,
      json['senha'] as String,
    );

Map<String, dynamic> _$AutenticacaoDTOToJson(AutenticacaoDTO instance) =>
    <String, dynamic>{
      'login': instance.login,
      'senha': instance.senha,
    };
