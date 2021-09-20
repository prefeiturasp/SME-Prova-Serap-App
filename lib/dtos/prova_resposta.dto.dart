import 'package:json_annotation/json_annotation.dart';

part 'prova_resposta.dto.g.dart';

@JsonSerializable()
class ProvaRespostaDTO {
  int questaoId;
  int? respostaAlternativa;
  String? respostaDescritiva;

  ProvaRespostaDTO({
    required this.questaoId,
    this.respostaAlternativa,
    this.respostaDescritiva,
  });

  static const fromJson = _$ProvaRespostaDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaRespostaDTOToJson(this);
}
