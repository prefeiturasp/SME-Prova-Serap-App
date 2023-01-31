import 'package:appserap/database/respostas.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resposta_prova.model.g.dart';

@JsonSerializable()
class RespostaProva implements Insertable<RespostaProva> {
  String codigoEOL;
  String dispositivoId;
  int provaId;
  String caderno;
  int questaoId;
  int? alternativaId;
  int? ordem;
  String? resposta;
  bool sincronizado = false;
  int tempoRespostaAluno;
  DateTime? dataHoraResposta = DateTime.now();

  RespostaProva({
    required this.codigoEOL,
    required this.dispositivoId,
    required this.provaId,
    required this.caderno,
    required this.questaoId,
    this.alternativaId,
    this.ordem,
    this.resposta,
    required this.sincronizado,
    this.dataHoraResposta,
    this.tempoRespostaAluno = 0,
  });

  factory RespostaProva.fromJson(Map<String, dynamic> json) => _$RespostaProvaFromJson(json);
  Map<String, dynamic> toJson() => _$RespostaProvaToJson(this);

  @override
  String toString() {
    return 'RespostaProva(codigoEOL: $codigoEOL, dispositivoId: $dispositivoId, questaoId: $questaoId, alternativaId: $alternativaId, resposta: $resposta, sincronizado: $sincronizado, dataHoraResposta: $dataHoraResposta)';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return RespostaProvaTableCompanion(
      codigoEOL: Value(codigoEOL),
      dispositivoId: Value(dispositivoId),
      provaId: Value(provaId),
      caderno: Value(caderno),
      questaoId: Value(questaoId),
      alternativaId: Value(alternativaId),
      ordem: Value(ordem),
      resposta: Value(resposta),
      sincronizado: Value(sincronizado),
      tempoRespostaAluno: Value(tempoRespostaAluno),
      dataHoraResposta: Value(dataHoraResposta),
    ).toColumns(nullToAbsent);
  }
}
