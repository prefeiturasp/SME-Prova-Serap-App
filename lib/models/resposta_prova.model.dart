import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resposta_prova.model.g.dart';

@JsonSerializable()
class RespostaProva implements Insertable<RespostaProva> {
  String codigoEOL;
  int provaId;
  int questaoId;
  int? alternativaId;
  String? resposta;
  bool sincronizado = false;
  int? tempoRespostaAluno;
  DateTime? dataHoraResposta = DateTime.now();

  RespostaProva({
    required this.codigoEOL,
    required this.provaId,
    required this.questaoId,
    this.alternativaId,
    this.resposta,
    required this.sincronizado,
    this.dataHoraResposta,
    this.tempoRespostaAluno,
  });

  factory RespostaProva.fromJson(Map<String, dynamic> json) => _$RespostaProvaFromJson(json);
  Map<String, dynamic> toJson() => _$RespostaProvaToJson(this);

  @override
  String toString() {
    return 'RespostaProva(codigoEOL: $codigoEOL, questaoId: $questaoId, alternativaId: $alternativaId, resposta: $resposta, sincronizado: $sincronizado, dataHoraResposta: $dataHoraResposta)';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return RespostaProvaTableCompanion(
      codigoEOL: Value(codigoEOL),
      provaId: Value(provaId),
      questaoId: Value(questaoId),
      alternativaId: Value(alternativaId),
      resposta: Value(resposta),
      sincronizado: Value(sincronizado),
      tempoRespostaAluno: Value(tempoRespostaAluno),
      dataHoraResposta: Value(dataHoraResposta),
    ).toColumns(nullToAbsent);
  }
}
