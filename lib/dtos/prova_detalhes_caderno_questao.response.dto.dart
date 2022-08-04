import 'package:json_annotation/json_annotation.dart';

part 'prova_detalhes_caderno_questao.response.dto.g.dart';

@JsonSerializable()
class ProvaDetalhesCadernoQuestaoResponseDTO {
  int questaoLegadoId;
  int ordem;

  ProvaDetalhesCadernoQuestaoResponseDTO({
    required this.questaoLegadoId,
    required this.ordem,
  });

  factory ProvaDetalhesCadernoQuestaoResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$ProvaDetalhesCadernoQuestaoResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProvaDetalhesCadernoQuestaoResponseDTOToJson(this);
}
