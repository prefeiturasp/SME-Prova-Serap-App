import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prova_resultado_resumo.response.dto.g.dart';

@JsonSerializable()
class ProvaResultadoResumoResponseDto {
  int idQuestaoLegado;
  String? descricaoQuestao;
  int ordemQuestao;
  EnumTipoQuestao tipoQuestao;
  String? alternativaAluno;
  bool alternativaCorreta;
  bool respostaConstruidaRespondida;
  double? proficiencia;

  ProvaResultadoResumoResponseDto({
    required this.idQuestaoLegado,
    required this.descricaoQuestao,
    required this.ordemQuestao,
    required this.tipoQuestao,
    required this.alternativaAluno,
    required this.alternativaCorreta,
    required this.respostaConstruidaRespondida,
    this.proficiencia,
  });

  static const fromJson = _$ProvaResultadoResumoResponseDtoFromJson;
  Map<String, dynamic> toJson() => _$ProvaResultadoResumoResponseDtoToJson(this);
}
