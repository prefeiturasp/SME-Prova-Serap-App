import 'package:json_annotation/json_annotation.dart';

import 'prova_resultado_resumo_questao.response.dto.dart';

part 'prova_resultado_resumo.response.dto.g.dart';

@JsonSerializable()
class ProvaResultadoResumoResponseDto {
  List<ProvaResultadoResumoQuestaoResponseDto> resumos;
  double proficiencia;

  ProvaResultadoResumoResponseDto({
    required this.resumos,
    required this.proficiencia,
  });

  static const fromJson = _$ProvaResultadoResumoResponseDtoFromJson;
  Map<String, dynamic> toJson() => _$ProvaResultadoResumoResponseDtoToJson(this);
}
