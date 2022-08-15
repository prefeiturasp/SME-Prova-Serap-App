import 'package:appserap/dtos/prova_detalhes_caderno_questao.response.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prova_detalhes_caderno.response.dto.g.dart';

@JsonSerializable()
class ProvaDetalhesCadernoResponseDTO {
  int provaId;
  List<ProvaDetalhesCadernoQuestaoResponseDTO> questoes;
  List<int> contextosProvaIds;

  ProvaDetalhesCadernoResponseDTO({
    required this.provaId,
    required this.questoes,
    required this.contextosProvaIds,
  });

  static const fromJson = _$ProvaDetalhesCadernoResponseDTOFromJson;

  Map<String, dynamic> toJson() => _$ProvaDetalhesCadernoResponseDTOToJson(this);
}
