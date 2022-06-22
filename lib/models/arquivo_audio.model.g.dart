// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arquivo_audio.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArquivoAudio _$ArquivoAudioFromJson(Map<String, dynamic> json) => ArquivoAudio(
      id: json['id'] as int,
      path: json['path'] as String,
      idQuestao: json['idQuestao'] as int,
      idProva: json['idProva'] as int,
    );

Map<String, dynamic> _$ArquivoAudioToJson(ArquivoAudio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'idQuestao': instance.idQuestao,
      'idProva': instance.idProva,
    };
