import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'questao_arquivo.model.g.dart';

@JsonSerializable()
class QuestaoArquivo implements Insertable<QuestaoArquivo> {
  int questaoLegadoId;
  int arquivoLegadoId;

  QuestaoArquivo({
    required this.questaoLegadoId,
    required this.arquivoLegadoId,
  });

  factory QuestaoArquivo.fromJson(Map<String, dynamic> json) => _$QuestaoArquivoFromJson(json);
  Map<String, dynamic> toJson() => _$QuestaoArquivoToJson(this);

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return QuestaoArquivoTableCompanion(
      questaoLegadoId: Value(questaoLegadoId),
      arquivoLegadoId: Value(arquivoLegadoId),
    ).toColumns(nullToAbsent);
  }
}
