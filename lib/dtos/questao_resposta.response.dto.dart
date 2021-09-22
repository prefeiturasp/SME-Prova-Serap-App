import 'package:json_annotation/json_annotation.dart';

part 'questao_resposta.response.dto.g.dart';

@JsonSerializable()
class QuestaoRespostaResponseDTO {
  int? alternativaId;
  String? resposta;

  QuestaoRespostaResponseDTO({
    this.alternativaId,
    this.resposta,
  });

  static const fromJson = _$QuestaoRespostaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$QuestaoRespostaResponseDTOToJson(this);
}
