import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'questao.model.g.dart';

@JsonSerializable()
class Questao implements Insertable<Questao> {
  int id;
  int provaId;

  String? titulo;
  String descricao;
  int ordem;
  EnumTipoQuestao tipo;

  int quantidadeAlternativas;

  Questao({
    required this.id,
    required this.provaId,
    this.titulo,
    required this.descricao,
    required this.ordem,
    required this.tipo,
    required this.quantidadeAlternativas,
  });

  factory Questao.fromJson(Map<String, dynamic> json) => _$QuestaoFromJson(json);
  Map<String, dynamic> toJson() => _$QuestaoToJson(this);

  @override
  String toString() {
    return 'Questao(id: $id, titulo: $titulo, descricao: $descricao, ordem: $ordem)';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return QuestoesDbCompanion(
      id: Value(id),
      titulo: Value(titulo),
      descricao: Value(descricao),
      ordem: Value(ordem),
      tipo: Value(tipo),
      quantidadeAlternativas: Value(quantidadeAlternativas),
      provaId: Value(provaId),
    ).toColumns(nullToAbsent);
  }
}
