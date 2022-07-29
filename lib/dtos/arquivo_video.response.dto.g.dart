// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arquivo_video.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArquivoVideoResponseDTO _$ArquivoVideoResponseDTOFromJson(
        Map<String, dynamic> json) =>
    ArquivoVideoResponseDTO(
      id: json['id'] as int,
      caminho: json['caminho'] as String,
      caminhoVideoConvertido: json['caminhoVideoConvertido'] as String?,
      caminhoVideoThumbinail: json['caminhoVideoThumbinail'] as String,
      questaoId: json['questaoId'] as int,
    );

Map<String, dynamic> _$ArquivoVideoResponseDTOToJson(
        ArquivoVideoResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caminho': instance.caminho,
      'caminhoVideoConvertido': instance.caminhoVideoConvertido,
      'caminhoVideoThumbinail': instance.caminhoVideoThumbinail,
      'questaoId': instance.questaoId,
    };
