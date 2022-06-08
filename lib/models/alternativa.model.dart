import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alternativa.model.g.dart';

@JsonSerializable()
class Alternativa implements Insertable<Alternativa> {
  int id;
  int provaId;
  int questaoId;
  String descricao;
  int ordem;
  String numeracao;

  Alternativa({
    required this.id,
    required this.provaId,
    required this.questaoId,
    required this.descricao,
    required this.ordem,
    required this.numeracao,
  });

  factory Alternativa.fromJson(Map<String, dynamic> json) => _$AlternativaFromJson(json);
  Map<String, dynamic> toJson() => _$AlternativaToJson(this);

  @override
  String toString() {
    return 'Alternativa(id: $id, descricao: $descricao, ordem: $ordem, numeracao: $numeracao, questaoId: $questaoId)';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return AlternativasDbCompanion(
      id: Value(id),
      provaId: Value(provaId),
      questaoId: Value(questaoId),
      descricao: Value(descricao),
      ordem: Value(ordem),
      numeracao: Value(numeracao),
    ).toColumns(nullToAbsent);
  }
}
