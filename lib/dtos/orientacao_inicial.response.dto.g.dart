// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orientacao_inicial.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrientacaoInicialResponseDTO _$OrientacaoInicialResponseDTOFromJson(
        Map<String, dynamic> json) =>
    OrientacaoInicialResponseDTO(
      id: json['id'] as int?,
      descricao: json['descricao'] as String?,
      ordem: json['ordem'] as int?,
      titulo: json['titulo'] as String?,
      imagem: json['imagem'] as String?,
    );

Map<String, dynamic> _$OrientacaoInicialResponseDTOToJson(
        OrientacaoInicialResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'ordem': instance.ordem,
      'titulo': instance.titulo,
      'imagem': instance.imagem,
    };
