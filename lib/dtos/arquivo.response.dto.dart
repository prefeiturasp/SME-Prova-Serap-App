import 'package:appserap/models/arquivo.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'arquivo.response.dto.g.dart';

@JsonSerializable()
class ArquivoResponseDTO {
  int id;
  int legadoId;
  String caminho;
  int questaoId;

  ArquivoResponseDTO({
    required this.id,
    required this.legadoId,
    required this.caminho,
    required this.questaoId,
  });

  static const fromJson = _$ArquivoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ArquivoResponseDTOToJson(this);

  Arquivo toModel() {
    return Arquivo(
      id: id,
      legadoId: legadoId,
      caminho: caminho,
      base64: "",
    );
  }

  @override
  String toString() => 'ArquivoResponseDTO(id: $id, caminho: $caminho, questaoId: $questaoId)';
}
