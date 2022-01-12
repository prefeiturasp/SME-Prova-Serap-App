import 'package:json_annotation/json_annotation.dart';

part 'arquivo_video.model.g.dart';

@JsonSerializable()
class ArquivoVideo {
  int id;
  String nome;
  String path;
  int idQuestao;
  int idProva;

  ArquivoVideo({
    required this.id,
    required this.nome,
    required this.path,
    required this.idQuestao,
    required this.idProva,
  });

  factory ArquivoVideo.fromJson(Map<String, dynamic> json) => _$ArquivoVideoFromJson(json);
  Map<String, dynamic> toJson() => _$ArquivoVideoToJson(this);

  @override
  String toString() => 'ArquivoVideo(id: $id, nome: $nome, path: $path, idQuestao: $idQuestao, idProva: $idProva)';
}
