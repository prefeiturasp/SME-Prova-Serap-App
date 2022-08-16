// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arquivo_video.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArquivoVideo _$ArquivoVideoFromJson(Map<String, dynamic> json) => ArquivoVideo(
      id: json['id'] as int,
      path: json['path'] as String,
      questaoLegadoId: json['questaoLegadoId'] as int,
    );

Map<String, dynamic> _$ArquivoVideoToJson(ArquivoVideo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'questaoLegadoId': instance.questaoLegadoId,
    };
