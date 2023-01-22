import 'package:json_annotation/json_annotation.dart';

import 'prova_detalhes_alternativa.response.dto.dart';

part 'prova_detalhes_caderno_questao.response.dto.g.dart';

@JsonSerializable()
class ProvaDetalhesCadernoQuestaoResponseDTO {
  int questaoId;
  int questaoLegadoId;
  int ordem;
  List<ProvaDetalhesAlternativaResponseDTO> alternativas;

  ProvaDetalhesCadernoQuestaoResponseDTO({
    required this.questaoId,
    required this.questaoLegadoId,
    required this.ordem,
    required this.alternativas,
  });

  static const fromJson = _$ProvaDetalhesCadernoQuestaoResponseDTOFromJson;

  Map<String, dynamic> toJson() => _$ProvaDetalhesCadernoQuestaoResponseDTOToJson(this);
}
