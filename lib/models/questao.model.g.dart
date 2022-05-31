// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questao _$QuestaoFromJson(Map<String, dynamic> json) => Questao(
      id: json['id'] as int,
      titulo: json['titulo'] as String?,
      descricao: json['descricao'] as String,
      ordem: json['ordem'] as int,
      alternativas: (json['alternativas'] as List<dynamic>)
          .map((e) => Alternativa.fromJson(e as Map<String, dynamic>))
          .toList(),
      arquivos: (json['arquivos'] as List<dynamic>)
          .map((e) => Arquivo.fromJson(e as Map<String, dynamic>))
          .toList(),
      tipo: _$enumDecode(_$EnumTipoQuestaoEnumMap, json['tipo']),
      quantidadeAlternativas: json['quantidadeAlternativas'] as int,
      arquivosVideos: (json['arquivosVideos'] as List<dynamic>)
          .map((e) => ArquivoVideo.fromJson(e as Map<String, dynamic>))
          .toList(),
      arquivosAudio: (json['arquivosAudio'] as List<dynamic>)
          .map((e) => ArquivoAudio.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestaoToJson(Questao instance) => <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'ordem': instance.ordem,
      'tipo': _$EnumTipoQuestaoEnumMap[instance.tipo],
      'quantidadeAlternativas': instance.quantidadeAlternativas,
      'alternativas': instance.alternativas,
      'arquivos': instance.arquivos,
      'arquivosVideos': instance.arquivosVideos,
      'arquivosAudio': instance.arquivosAudio,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$EnumTipoQuestaoEnumMap = {
  EnumTipoQuestao.NAO_CADASTRADO: 0,
  EnumTipoQuestao.MULTIPLA_ESCOLHA: 1,
  EnumTipoQuestao.RESPOSTA_CONTRUIDA: 2,
};
