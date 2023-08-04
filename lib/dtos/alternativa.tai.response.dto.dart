import 'package:appserap/models/alternativa.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alternativa.tai.response.dto.g.dart';

@JsonSerializable()
class AlternativaTaiResponseDTO {
  int id;
  String descricao;
  int ordem;
  String numeracao;
  @JsonKey(name: 'questaoId')
  int questaoId;

  AlternativaTaiResponseDTO({
    required this.id,
    required this.descricao,
    required this.ordem,
    required this.numeracao,
    required this.questaoId,
  });

  static const fromJson = _$AlternativaTaiResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AlternativaTaiResponseDTOToJson(this);

  Alternativa toModel() {
    return Alternativa(
      id: id,
      questaoLegadoId: questaoId,
      descricao: descricao,
      ordem: ordem,
      numeracao: numeracao,
    );
  }

  @override
  String toString() {
    return 'AlternativaTaiResponseDTO(id: $id, descricao: $descricao, ordem: $ordem, numeracao: $numeracao, questaoId: $questaoId)';
  }
}
