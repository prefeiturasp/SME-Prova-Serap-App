import 'package:json_annotation/json_annotation.dart';

part 'prova_detalhes_caderno_questao.response.dto.g.dart';

@JsonSerializable()
class ProvaDetalhesCadernoQuestaoResponseDTO {
  int questaoId;
  int questaoLegadoId;
  int ordem;

  ProvaDetalhesCadernoQuestaoResponseDTO({
    required this.questaoId,
    required this.questaoLegadoId,
    required this.ordem,
  });

  static const fromJson = _$ProvaDetalhesCadernoQuestaoResponseDTOFromJson;

  Map<String, dynamic> toJson() => _$ProvaDetalhesCadernoQuestaoResponseDTOToJson(this);
}
