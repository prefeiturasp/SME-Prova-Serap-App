import 'package:json_annotation/json_annotation.dart';

import 'questao_completa.response.dto.dart';

part 'questao_completa_resposta.response.dto.g.dart';

@JsonSerializable()
class QuestaoCompletaRespostaResponseDto {
  QuestaoCompletaResponseDTO questao;
  int? ordemAlternativaCorreta;
  int? ordemAlternativaResposta;
  String? respostaConstruida;

  QuestaoCompletaRespostaResponseDto({
    required this.questao,
    required this.ordemAlternativaCorreta,
    required this.ordemAlternativaResposta,
  });

  static const fromJson = _$QuestaoCompletaRespostaResponseDtoFromJson;
  Map<String, dynamic> toJson() => _$QuestaoCompletaRespostaResponseDtoToJson(this);
}
