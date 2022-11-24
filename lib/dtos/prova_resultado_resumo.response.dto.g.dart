// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_resultado_resumo.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaResultadoResumoResponseDto _$ProvaResultadoResumoResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ProvaResultadoResumoResponseDto(
      idQuestaoLegado: json['idQuestaoLegado'] as int,
      descricaoQuestao: json['descricaoQuestao'] as String?,
      ordemQuestao: json['ordemQuestao'] as int,
      tipoQuestao: $enumDecode(_$EnumTipoQuestaoEnumMap, json['tipoQuestao']),
      alternativaAluno: json['alternativaAluno'] as String?,
      alternativaCorreta: json['alternativaCorreta'] as bool,
      respostaConstruidaRespondida:
          json['respostaConstruidaRespondida'] as bool,
      proficiencia: (json['proficiencia'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProvaResultadoResumoResponseDtoToJson(
        ProvaResultadoResumoResponseDto instance) =>
    <String, dynamic>{
      'idQuestaoLegado': instance.idQuestaoLegado,
      'descricaoQuestao': instance.descricaoQuestao,
      'ordemQuestao': instance.ordemQuestao,
      'tipoQuestao': _$EnumTipoQuestaoEnumMap[instance.tipoQuestao]!,
      'alternativaAluno': instance.alternativaAluno,
      'alternativaCorreta': instance.alternativaCorreta,
      'respostaConstruidaRespondida': instance.respostaConstruidaRespondida,
      'proficiencia': instance.proficiencia,
    };

const _$EnumTipoQuestaoEnumMap = {
  EnumTipoQuestao.NAO_CADASTRADO: 0,
  EnumTipoQuestao.MULTIPLA_ESCOLHA: 1,
  EnumTipoQuestao.RESPOSTA_CONTRUIDA: 2,
};
