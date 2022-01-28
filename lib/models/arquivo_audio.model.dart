import 'package:json_annotation/json_annotation.dart';

part 'arquivo_audio.model.g.dart';

@JsonSerializable()
class ArquivoAudio {
  int id;
  String path;
  int idQuestao;
  int idProva;

  ArquivoAudio({
    required this.id,
    required this.path,
    required this.idQuestao,
    required this.idProva,
  });

  factory ArquivoAudio.fromJson(Map<String, dynamic> json) => _$ArquivoAudioFromJson(json);
  Map<String, dynamic> toJson() => _$ArquivoAudioToJson(this);

  @override
  String toString() => 'ArquivoAudio(id: $id, path: $path, idQuestao: $idQuestao, idProva: $idProva)';
}
