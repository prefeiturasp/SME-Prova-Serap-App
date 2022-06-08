// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arquivo.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Arquivo _$ArquivoFromJson(Map<String, dynamic> json) => Arquivo(
      id: json['id'] as int,
      legadoId: json['legadoId'] as int,
      provaId: json['provaId'] as int,
      questaoId: json['questaoId'] as int,
      caminho: json['caminho'] as String,
      base64: json['base64'] as String,
    );

Map<String, dynamic> _$ArquivoToJson(Arquivo instance) => <String, dynamic>{
      'id': instance.id,
      'legadoId': instance.legadoId,
      'provaId': instance.provaId,
      'questaoId': instance.questaoId,
      'caminho': instance.caminho,
      'base64': instance.base64,
    };
