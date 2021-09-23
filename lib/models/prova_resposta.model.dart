import 'package:json_annotation/json_annotation.dart';

part 'prova_resposta.model.g.dart';

@JsonSerializable()
class ProvaResposta {
  int questaoId;
  int? alternativaId;
  String? resposta;
  bool sincronizado = false;
  DateTime? dataHoraResposta = DateTime.now();

  ProvaResposta({
    required this.questaoId,
    this.alternativaId,
    this.resposta,
    required this.sincronizado,
    this.dataHoraResposta,
  });

  factory ProvaResposta.fromJson(Map<String, dynamic> json) => _$ProvaRespostaFromJson(json);
  Map<String, dynamic> toJson() => _$ProvaRespostaToJson(this);

  @override
  String toString() {
    return 'ProvaResposta(questaoId: $questaoId, alternativaId: $alternativaId, resposta: $resposta, sincronizado: $sincronizado, dataHoraResposta: $dataHoraResposta)';
  }
}
