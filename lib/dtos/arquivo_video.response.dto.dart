import 'package:json_annotation/json_annotation.dart';

part 'arquivo_video.response.dto.g.dart';

@JsonSerializable()
class ArquivoVideoResponseDTO {
  int id;
  String urlVideo;
  String nomeArquivo;
  int idProva;
  int idQuestao;

  ArquivoVideoResponseDTO({
    required this.id,
    required this.urlVideo,
    required this.nomeArquivo,
    required this.idProva,
    required this.idQuestao,
  });

  static const fromJson = _$ArquivoVideoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ArquivoVideoResponseDTOToJson(this);
}
