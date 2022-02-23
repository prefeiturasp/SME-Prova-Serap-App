import 'package:json_annotation/json_annotation.dart';

part 'arquivo_video.response.dto.g.dart';

@JsonSerializable()
class ArquivoVideoResponseDTO {
  int id;
  String caminho;
  String caminhoVideoConvertido;
  String caminhoVideoThumbinail;
  int questaoId;

  ArquivoVideoResponseDTO({
    required this.id,
    required this.caminho,
    required this.caminhoVideoConvertido,
    required this.caminhoVideoThumbinail,
    required this.questaoId,
  });

  static const fromJson = _$ArquivoVideoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ArquivoVideoResponseDTOToJson(this);
}
