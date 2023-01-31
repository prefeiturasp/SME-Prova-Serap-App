import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prova_questao_alternativa.model.g.dart';

@JsonSerializable()
class ProvaQuestaoAlternativa implements Insertable<ProvaQuestaoAlternativa> {
  int provaId;
  String caderno;
  int ordem;
  int questaoId;
  int questaoLegadoId;
  int alternativaId;
  int alternativaLegadoId;

  ProvaQuestaoAlternativa({
    required this.provaId,
    required this.caderno,
    required this.ordem,
    required this.questaoId,
    required this.questaoLegadoId,
    required this.alternativaId,
    required this.alternativaLegadoId,
  });

  factory ProvaQuestaoAlternativa.fromJson(Map<String, dynamic> json) => _$ProvaQuestaoAlternativaFromJson(json);
  Map<String, dynamic> toJson() => _$ProvaQuestaoAlternativaToJson(this);

  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return ProvaQuestaoAlternativaTableCompanion(
      provaId: Value(provaId),
      caderno: Value(caderno),
      ordem: Value(ordem),
      questaoLegadoId: Value(questaoLegadoId),
      questaoId: Value(questaoId),
      alternativaId: Value(alternativaId),
      alternativaLegadoId: Value(alternativaLegadoId),
    ).toColumns(nullToAbsent);
  }
}
