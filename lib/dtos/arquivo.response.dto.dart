import 'package:json_annotation/json_annotation.dart';

part 'arquivo.response.dto.g.dart';

@JsonSerializable()
class ArquivoResponseDTO {
  int id;
  String caminho;
  int questaoId;
  ArquivoResponseDTO({
    required this.id,
    required this.caminho,
    required this.questaoId,
  });

  static const fromJson = _$ArquivoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ArquivoResponseDTOToJson(this);

  @override
  String toString() => 'ArquivoResponseDTO(id: $id, caminho: $caminho, questaoId: $questaoId)';
}
