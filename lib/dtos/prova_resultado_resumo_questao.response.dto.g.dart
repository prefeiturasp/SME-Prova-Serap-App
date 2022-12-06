// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_resultado_resumo_questao.response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaResultadoResumoQuestaoResponseDto
    _$ProvaResultadoResumoQuestaoResponseDtoFromJson(
            Map<String, dynamic> json) =>
        ProvaResultadoResumoQuestaoResponseDto(
          idQuestaoLegado: json['idQuestaoLegado'] as int,
          descricaoQuestao: json['descricaoQuestao'] as String?,
          ordemQuestao: json['ordemQuestao'] as int,
          tipoQuestao:
              $enumDecode(_$EnumTipoQuestaoEnumMap, json['tipoQuestao']),
          alternativaAluno: json['alternativaAluno'] as String?,
          alternativaCorreta: json['alternativaCorreta'] as String,
          correta: json['correta'] as bool,
          respostaConstruidaRespondida:
              json['respostaConstruidaRespondida'] as bool,
        );

Map<String, dynamic> _$ProvaResultadoResumoQuestaoResponseDtoToJson(
        ProvaResultadoResumoQuestaoResponseDto instance) =>
    <String, dynamic>{
      'idQuestaoLegado': instance.idQuestaoLegado,
      'descricaoQuestao': instance.descricaoQuestao,
      'ordemQuestao': instance.ordemQuestao,
      'tipoQuestao': _$EnumTipoQuestaoEnumMap[instance.tipoQuestao]!,
      'alternativaAluno': instance.alternativaAluno,
      'alternativaCorreta': instance.alternativaCorreta,
      'correta': instance.correta,
      'respostaConstruidaRespondida': instance.respostaConstruidaRespondida,
    };

const _$EnumTipoQuestaoEnumMap = {
  EnumTipoQuestao.NAO_CADASTRADO: 0,
  EnumTipoQuestao.MULTIPLA_ESCOLHA: 1,
  EnumTipoQuestao.RESPOSTA_CONTRUIDA: 2,
};
