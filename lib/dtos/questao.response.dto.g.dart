// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestaoResponseDTO _$QuestaoResponseDTOFromJson(Map<String, dynamic> json) =>
    QuestaoResponseDTO(
      id: json['id'] as int,
      titulo: json['titulo'] as String?,
      descricao: json['descricao'] as String,
      ordem: json['ordem'] as int,
      tipo: _$enumDecode(_$EnumTipoQuestaoEnumMap, json['tipo']),
      quantidadeAlternativas: json['quantidadeAlternativas'] as int,
    );

Map<String, dynamic> _$QuestaoResponseDTOToJson(QuestaoResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'ordem': instance.ordem,
      'tipo': _$EnumTipoQuestaoEnumMap[instance.tipo],
      'quantidadeAlternativas': instance.quantidadeAlternativas,
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
