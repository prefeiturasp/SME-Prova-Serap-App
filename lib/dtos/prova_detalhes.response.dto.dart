import 'package:json_annotation/json_annotation.dart';

part 'prova_detalhes.response.dto.g.dart';

@JsonSerializable()
class ProvaDetalhesResponseDTO {
  int provaId;
  List<int> questoesIds;
  List<int> contextosProvaIds;

  ProvaDetalhesResponseDTO({
    required this.provaId,
    required this.questoesIds,
    required this.contextosProvaIds,
  });

  static const fromJson = _$ProvaDetalhesResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaDetalhesResponseDTOToJson(this);

  @override
  String toString() {
    return 'ProvaDetalhesResponseDTO(provaId: $provaId, questoesIds: $questoesIds, contextosProvaIds: $contextosProvaIds)';
  }
}
