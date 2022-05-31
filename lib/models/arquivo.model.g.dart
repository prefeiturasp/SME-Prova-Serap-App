// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arquivo.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Arquivo _$ArquivoFromJson(Map<String, dynamic> json) => Arquivo(
      id: json['id'] as int,
      caminho: json['caminho'] as String,
      base64: json['base64'] as String,
      questaoId: json['questaoId'] as int,
    );

Map<String, dynamic> _$ArquivoToJson(Arquivo instance) => <String, dynamic>{
      'id': instance.id,
      'caminho': instance.caminho,
      'base64': instance.base64,
      'questaoId': instance.questaoId,
    };
