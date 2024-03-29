import 'package:appserap/database/app.database.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alternativa.model.g.dart';

@JsonSerializable()
class Alternativa implements Insertable<Alternativa> {
  int id;
  int questaoLegadoId;
  String descricao;
  int ordem;
  String numeracao;

  Alternativa({
    required this.id,
    required this.questaoLegadoId,
    required this.descricao,
    required this.ordem,
    required this.numeracao,
  });

  factory Alternativa.fromJson(Map<String, dynamic> json) => _$AlternativaFromJson(json);
  Map<String, dynamic> toJson() => _$AlternativaToJson(this);

  @override
  String toString() {
    return 'Alternativa(id: $id, questaoLegadoId: $questaoLegadoId, descricao: $descricao, ordem: $ordem, numeracao: $numeracao)';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return AlternativasDbCompanion(
      id: Value(id),
      questaoLegadoId: Value(questaoLegadoId),
      descricao: Value(descricao),
      ordem: Value(ordem),
      numeracao: Value(numeracao),
    ).toColumns(nullToAbsent);
  }
}
