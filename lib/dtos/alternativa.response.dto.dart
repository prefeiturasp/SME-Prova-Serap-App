import 'package:json_annotation/json_annotation.dart';

part 'alternativa.response.dto.g.dart';

@JsonSerializable()
class AlternativaResponseDTO {
  int id;
  String descricao;
  int ordem;
  String numeracao;
  int questaoId;

  AlternativaResponseDTO({
    required this.id,
    required this.descricao,
    required this.ordem,
    required this.numeracao,
    required this.questaoId,
  });

  static const fromJson = _$AlternativaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AlternativaResponseDTOToJson(this);

  @override
  String toString() {
    return 'AlternativaResponseDTO(id: $id, descricao: $descricao, ordem: $ordem, numeracao: $numeracao, questaoId: $questaoId)';
  }
}
