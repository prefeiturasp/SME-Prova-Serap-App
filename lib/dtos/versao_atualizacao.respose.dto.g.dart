// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'versao_atualizacao.respose.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VersaoAtualizacaoResponseDTO _$VersaoAtualizacaoResponseDTOFromJson(
        Map<String, dynamic> json) =>
    VersaoAtualizacaoResponseDTO(
      versionCode: json['versionCode'] as int?,
      versionName: json['versionName'] as String?,
      contentText: json['contentText'] as String?,
      minSupport: json['minSupport'] as int?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$VersaoAtualizacaoResponseDTOToJson(
        VersaoAtualizacaoResponseDTO instance) =>
    <String, dynamic>{
      'versionCode': instance.versionCode,
      'versionName': instance.versionName,
      'contentText': instance.contentText,
      'minSupport': instance.minSupport,
      'url': instance.url,
    };
