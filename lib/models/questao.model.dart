import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'questao.model.g.dart';

@JsonSerializable()
class Questao implements Insertable<Questao> {
  int questaoLegadoId;

  String? titulo;
  String descricao;
  EnumTipoQuestao tipo;

  int quantidadeAlternativas;

  Questao({
    required this.questaoLegadoId,
    this.titulo,
    required this.descricao,
    required this.tipo,
    required this.quantidadeAlternativas,
  });

  factory Questao.fromJson(Map<String, dynamic> json) => _$QuestaoFromJson(json);
  Map<String, dynamic> toJson() => _$QuestaoToJson(this);

  @override
  String toString() {
    return 'Questao(questaoLegadoId: $questaoLegadoId, titulo: $titulo, descricao: $descricao)';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return QuestoesDbCompanion(
      questaoLegadoId: Value(questaoLegadoId),
      titulo: Value(titulo),
      descricao: Value(descricao),
      tipo: Value(tipo),
      quantidadeAlternativas: Value(quantidadeAlternativas),
    ).toColumns(nullToAbsent);
  }
}
