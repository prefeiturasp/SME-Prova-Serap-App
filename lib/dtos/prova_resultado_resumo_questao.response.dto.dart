import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prova_resultado_resumo_questao.response.dto.g.dart';

@JsonSerializable()
class ProvaResultadoResumoQuestaoResponseDto {
  int idQuestaoLegado;
  String? descricaoQuestao;
  int ordemQuestao;
  EnumTipoQuestao tipoQuestao;
  String? alternativaAluno;
  String alternativaCorreta;
  bool correta;
  bool respostaConstruidaRespondida;

  ProvaResultadoResumoQuestaoResponseDto({
    required this.idQuestaoLegado,
    required this.descricaoQuestao,
    required this.ordemQuestao,
    required this.tipoQuestao,
    required this.alternativaAluno,
    required this.alternativaCorreta,
    required this.correta,
    required this.respostaConstruidaRespondida,
  });

  static const fromJson = _$ProvaResultadoResumoQuestaoResponseDtoFromJson;
  Map<String, dynamic> toJson() => _$ProvaResultadoResumoQuestaoResponseDtoToJson(this);
}
