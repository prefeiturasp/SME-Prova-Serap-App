// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_completa.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestaoCompletaResponseDTO _$QuestaoCompletaResponseDTOFromJson(
        Map<String, dynamic> json) =>
    QuestaoCompletaResponseDTO(
      id: json['id'] as int,
      titulo: json['titulo'] as String?,
      descricao: json['descricao'] as String,
      ordem: json['ordem'] as int,
      tipo: $enumDecode(_$EnumTipoQuestaoEnumMap, json['tipo']),
      quantidadeAlternativas: json['quantidadeAlternativas'] as int,
      arquivos: (json['arquivos'] as List<dynamic>)
          .map((e) => ArquivoResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      audios: (json['audios'] as List<dynamic>)
          .map((e) => ArquivoResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      videos: (json['videos'] as List<dynamic>)
          .map((e) =>
              ArquivoVideoResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      alternativas: (json['alternativas'] as List<dynamic>)
          .map(
              (e) => AlternativaResponseDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestaoCompletaResponseDTOToJson(
        QuestaoCompletaResponseDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'ordem': instance.ordem,
      'tipo': _$EnumTipoQuestaoEnumMap[instance.tipo]!,
      'quantidadeAlternativas': instance.quantidadeAlternativas,
      'arquivos': instance.arquivos,
      'audios': instance.audios,
      'videos': instance.videos,
      'alternativas': instance.alternativas,
    };

const _$EnumTipoQuestaoEnumMap = {
  EnumTipoQuestao.NAO_CADASTRADO: 0,
  EnumTipoQuestao.MULTIPLA_ESCOLHA: 1,
  EnumTipoQuestao.RESPOSTA_CONTRUIDA: 2,
};
