import 'package:json_annotation/json_annotation.dart';

part 'prova_resumo_tai.response.dto.g.dart';

@JsonSerializable()
class ProvaResumoTaiResponseDto {
  int ordemQuestao;
  String descricaoQuestao;
  String alternativaAluno;

  ProvaResumoTaiResponseDto({
    required this.ordemQuestao,
    required this.descricaoQuestao,
    required this.alternativaAluno,
  });

  static const fromJson = _$ProvaResumoTaiResponseDtoFromJson;
  Map<String, dynamic> toJson() => _$ProvaResumoTaiResponseDtoToJson(this);
}
