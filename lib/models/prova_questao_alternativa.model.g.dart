// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_questao_alternativa.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvaQuestaoAlternativa _$ProvaQuestaoAlternativaFromJson(
        Map<String, dynamic> json) =>
    ProvaQuestaoAlternativa(
      provaId: json['provaId'] as int,
      caderno: json['caderno'] as String,
      ordem: json['ordem'] as int,
      questaoId: json['questaoId'] as int,
      questaoLegadoId: json['questaoLegadoId'] as int,
      alternativaId: json['alternativaId'] as int,
      alternativaLegadoId: json['alternativaLegadoId'] as int,
    );

Map<String, dynamic> _$ProvaQuestaoAlternativaToJson(
        ProvaQuestaoAlternativa instance) =>
    <String, dynamic>{
      'provaId': instance.provaId,
      'caderno': instance.caderno,
      'ordem': instance.ordem,
      'questaoId': instance.questaoId,
      'questaoLegadoId': instance.questaoLegadoId,
      'alternativaId': instance.alternativaId,
      'alternativaLegadoId': instance.alternativaLegadoId,
    };
