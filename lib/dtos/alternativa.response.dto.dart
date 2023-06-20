import 'package:appserap/models/alternativa.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alternativa.response.dto.g.dart';

@JsonSerializable()
class AlternativaResponseDTO {
  @JsonKey(name: 'alternativaLegadoId')
  int id;
  String descricao;
  int ordem;
  String numeracao;
  @JsonKey(name: 'questaoId')
  int questaoLegadoId;

  AlternativaResponseDTO({
    required this.id,
    required this.descricao,
    required this.ordem,
    required this.numeracao,
    required this.questaoLegadoId,
  });

  static const fromJson = _$AlternativaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AlternativaResponseDTOToJson(this);

  Alternativa toModel() {
    return Alternativa(
      id: id,
      questaoLegadoId: questaoLegadoId,
      descricao: descricao,
      ordem: ordem,
      numeracao: numeracao,
    );
  }

  @override
  String toString() {
    return 'AlternativaResponseDTO(id: $id, descricao: $descricao, ordem: $ordem, numeracao: $numeracao, questaoLegadoId: $questaoLegadoId)';
  }
}
