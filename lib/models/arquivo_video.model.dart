import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'arquivo_video.model.g.dart';

@JsonSerializable()
class ArquivoVideo implements Insertable<ArquivoVideo> {
  int id;
  String path;
  int questaoLegadoId;

  ArquivoVideo({
    required this.id,
    required this.path,
    required this.questaoLegadoId,
  });

  factory ArquivoVideo.fromJson(Map<String, dynamic> json) => _$ArquivoVideoFromJson(json);
  Map<String, dynamic> toJson() => _$ArquivoVideoToJson(this);

  @override
  String toString() => 'ArquivoVideo(id: $id, path: $path, questaoLegadoId: $questaoLegadoId)';

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ArquivosVideoDbCompanion(
      id: Value(id),
      path: Value(path),
      questaoLegadoId: Value(questaoLegadoId),
    ).toColumns(nullToAbsent);
  }
}
