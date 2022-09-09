import 'package:json_annotation/json_annotation.dart';

part 'questao_resposta.dto.g.dart';

@JsonSerializable()
class QuestaoRespostaDTO {
  String alunoRa;
  String dispositivoId;
  int questaoId;
  int? alternativaId;
  String? resposta;
  int dataHoraRespostaTicks;
  int? tempoRespostaAluno;

  QuestaoRespostaDTO({
    required this.alunoRa,
    required this.dispositivoId,
    required this.questaoId,
    this.alternativaId,
    this.resposta,
    required this.dataHoraRespostaTicks,
    this.tempoRespostaAluno,
  });

  static const fromJson = _$QuestaoRespostaDTOFromJson;
  Map<String, dynamic> toJson() => _$QuestaoRespostaDTOToJson(this);
}
