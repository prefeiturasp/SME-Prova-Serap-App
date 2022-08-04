// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_detalhes_legado.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestaoDetalhesLegadoResponseDTO _$QuestaoDetalhesLegadoResponseDTOFromJson(
        Map<String, dynamic> json) =>
    QuestaoDetalhesLegadoResponseDTO(
      id: json['id'] as int,
      titulo: json['titulo'] as String?,
      descricao: json['descricao'] as String,
      ordem: json['ordem'] as int,
      tipo: $enumDecode(_$EnumTipoQuestaoEnumMap, json['tipo']),
      quantidadeAlternativas: json['quantidadeAlternativas'] as int,
    );

Map<String, dynamic> _$QuestaoDetalhesLegadoResponseDTOToJson(
        QuestaoDetalhesLegadoResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'ordem': instance.ordem,
      'tipo': _$EnumTipoQuestaoEnumMap[instance.tipo]!,
      'quantidadeAlternativas': instance.quantidadeAlternativas,
    };

const _$EnumTipoQuestaoEnumMap = {
  EnumTipoQuestao.NAO_CADASTRADO: 0,
  EnumTipoQuestao.MULTIPLA_ESCOLHA: 1,
  EnumTipoQuestao.RESPOSTA_CONTRUIDA: 2,
};
