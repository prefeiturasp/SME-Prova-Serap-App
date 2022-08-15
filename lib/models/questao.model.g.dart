// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questao _$QuestaoFromJson(Map<String, dynamic> json) => Questao(
      questaoLegadoId: json['questaoLegadoId'] as int,
      titulo: json['titulo'] as String?,
      descricao: json['descricao'] as String,
      tipo: $enumDecode(_$EnumTipoQuestaoEnumMap, json['tipo']),
      quantidadeAlternativas: json['quantidadeAlternativas'] as int,
    );

Map<String, dynamic> _$QuestaoToJson(Questao instance) => <String, dynamic>{
      'questaoLegadoId': instance.questaoLegadoId,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'tipo': _$EnumTipoQuestaoEnumMap[instance.tipo]!,
      'quantidadeAlternativas': instance.quantidadeAlternativas,
    };

const _$EnumTipoQuestaoEnumMap = {
  EnumTipoQuestao.NAO_CADASTRADO: 0,
  EnumTipoQuestao.MULTIPLA_ESCOLHA: 1,
  EnumTipoQuestao.RESPOSTA_CONTRUIDA: 2,
};
