import 'package:json_annotation/json_annotation.dart';

part 'alternativa.model.g.dart';

@JsonSerializable()
class Alternativa {
  int id;
  String descricao;
  int ordem;
  String numeracao;
  int questaoId;

  Alternativa({
    required this.id,
    required this.descricao,
    required this.ordem,
    required this.numeracao,
    required this.questaoId,
  });

  factory Alternativa.fromJson(Map<String, dynamic> json) => _$AlternativaFromJson(json);
  Map<String, dynamic> toJson() => _$AlternativaToJson(this);

  @override
  String toString() {
    return 'Alternativa(id: $id, descricao: $descricao, ordem: $ordem, numeracao: $numeracao, questaoId: $questaoId)';
  }
}
