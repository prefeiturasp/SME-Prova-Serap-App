import 'package:json_annotation/json_annotation.dart';

part 'questao_resposta.response.dto.g.dart';

@JsonSerializable()
class QuestaoRespostaResponseDTO {
  int? alternativaId;
  String? resposta;
  DateTime dataHoraResposta;
  int questaoId;

  QuestaoRespostaResponseDTO({
    required this.questaoId,
    this.alternativaId,
    this.resposta,
    required this.dataHoraResposta,
  });

  static const fromJson = _$QuestaoRespostaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$QuestaoRespostaResponseDTOToJson(this);

  @override
  String toString() =>
      'QuestaoRespostaResponseDTO(alternativaId: $alternativaId, resposta: $resposta, dataHoraResposta: $dataHoraResposta)';
}
