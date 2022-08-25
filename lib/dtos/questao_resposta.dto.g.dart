// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_resposta.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestaoRespostaDTO _$QuestaoRespostaDTOFromJson(Map<String, dynamic> json) =>
    QuestaoRespostaDTO(
      alunoRa: json['alunoRa'] as String,
      questaoId: json['questaoId'] as int,
      alternativaId: json['alternativaId'] as int?,
      resposta: json['resposta'] as String?,
      dataHoraRespostaTicks: json['dataHoraRespostaTicks'] as int,
      tempoRespostaAluno: json['tempoRespostaAluno'] as int?,
    );

Map<String, dynamic> _$QuestaoRespostaDTOToJson(QuestaoRespostaDTO instance) =>
    <String, dynamic>{
      'alunoRa': instance.alunoRa,
      'questaoId': instance.questaoId,
      'alternativaId': instance.alternativaId,
      'resposta': instance.resposta,
      'dataHoraRespostaTicks': instance.dataHoraRespostaTicks,
      'tempoRespostaAluno': instance.tempoRespostaAluno,
    };
