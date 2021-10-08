import 'package:json_annotation/json_annotation.dart';

part 'tempo_resposta.model.g.dart';

@JsonSerializable()
class TempoResposta {
  int questaoId;
  int? tempo;

  TempoResposta({
    required this.questaoId,
    this.tempo,
  });

  factory TempoResposta.fromJson(Map<String, dynamic> json) =>
      _$TempoRespostaFromJson(json);
  Map<String, dynamic> toJson() => _$TempoRespostaToJson(this);

  @override
  String toString() {
    return 'TempoResposta(questaoId: $questaoId, tempo: $tempo)';
  }
}
