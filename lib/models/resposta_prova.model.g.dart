// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resposta_prova.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RespostaProva _$RespostaProvaFromJson(Map<String, dynamic> json) =>
    RespostaProva(
      codigoEOL: json['codigoEOL'] as String,
      provaId: json['provaId'] as int,
      questaoId: json['questaoId'] as int,
      alternativaId: json['alternativaId'] as int?,
      resposta: json['resposta'] as String?,
      sincronizado: json['sincronizado'] as bool,
      dataHoraResposta: json['dataHoraResposta'] == null
          ? null
          : DateTime.parse(json['dataHoraResposta'] as String),
      tempoRespostaAluno: json['tempoRespostaAluno'] as int? ?? 0,
    );

Map<String, dynamic> _$RespostaProvaToJson(RespostaProva instance) =>
    <String, dynamic>{
      'codigoEOL': instance.codigoEOL,
      'provaId': instance.provaId,
      'questaoId': instance.questaoId,
      'alternativaId': instance.alternativaId,
      'resposta': instance.resposta,
      'sincronizado': instance.sincronizado,
      'tempoRespostaAluno': instance.tempoRespostaAluno,
      'dataHoraResposta': instance.dataHoraResposta?.toIso8601String(),
    };
