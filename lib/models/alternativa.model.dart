import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alternativa.model.g.dart';

@JsonSerializable()
class Alternativa implements Insertable<Alternativa> {
  int legadoId;
  int questaoLegadoId;
  String descricao;
  int ordem;
  String numeracao;

  Alternativa({
    required this.legadoId,
    required this.questaoLegadoId,
    required this.descricao,
    required this.ordem,
    required this.numeracao,
  });

  factory Alternativa.fromJson(Map<String, dynamic> json) => _$AlternativaFromJson(json);
  Map<String, dynamic> toJson() => _$AlternativaToJson(this);

  @override
  String toString() {
    return 'Alternativa(legadoId: $legadoId, descricao: $descricao, ordem: $ordem, numeracao: $numeracao, questaoLegadoId: $questaoLegadoId)';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return AlternativasDbCompanion(
      legadoId: Value(legadoId),
      questaoLegadoId: Value(questaoLegadoId),
      descricao: Value(descricao),
      ordem: Value(ordem),
      numeracao: Value(numeracao),
    ).toColumns(nullToAbsent);
  }
}
