import 'package:json_annotation/json_annotation.dart';

part 'questao_resposta.dto.g.dart';

@JsonSerializable()
class QuestaoRespostaDTO {
  int questaoId;
  int? alternativaId;
  String? resposta;
  int dataHoraRespostaTicks = 0;

  QuestaoRespostaDTO({
    required this.questaoId,
    this.alternativaId,
    this.resposta,
    required this.dataHoraRespostaTicks,
  });

  static const fromJson = _$QuestaoRespostaDTOFromJson;
  Map<String, dynamic> toJson() => _$QuestaoRespostaDTOToJson(this);
}
