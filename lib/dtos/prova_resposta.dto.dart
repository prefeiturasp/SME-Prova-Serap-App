import 'package:json_annotation/json_annotation.dart';

part 'prova_resposta.dto.g.dart';

@JsonSerializable()
class ProvaRespostaDTO {
  int questaoId;
  int? alternativaId;
  String? resposta;
  bool sincronizado = false;
  int dataHoraRespostaTicks = 0;

  ProvaRespostaDTO({
    required this.questaoId,
    this.alternativaId,
    this.resposta,
    required this.sincronizado,
    required this.dataHoraRespostaTicks,
  });

  static const fromJson = _$ProvaRespostaDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaRespostaDTOToJson(this);
}
