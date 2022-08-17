import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'arquivo_audio.model.g.dart';

@JsonSerializable()
class ArquivoAudio implements Insertable<ArquivoAudio> {
  int id;
  String path;
  int questaoLegadoId;

  ArquivoAudio({
    required this.id,
    required this.path,
    required this.questaoLegadoId,
  });

  factory ArquivoAudio.fromJson(Map<String, dynamic> json) => _$ArquivoAudioFromJson(json);
  Map<String, dynamic> toJson() => _$ArquivoAudioToJson(this);

  @override
  String toString() => 'ArquivoAudio(id: $id, path: $path, questaoLegadoId: $questaoLegadoId)';

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ArquivosAudioDbCompanion(
      id: Value(id),
      path: Value(path),
      questaoLegadoId: Value(questaoLegadoId),
    ).toColumns(nullToAbsent);
  }
}
