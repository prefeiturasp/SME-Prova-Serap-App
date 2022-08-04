import 'package:appserap/database/app.database.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'questao.model.g.dart';

@JsonSerializable()
class Questao implements Insertable<Questao> {
  int id;

  String? titulo;
  String descricao;
  EnumTipoQuestao tipo;

  int quantidadeAlternativas;

  String caderno;

  Questao({
    required this.id,
    this.titulo,
    required this.descricao,
    required this.tipo,
    required this.quantidadeAlternativas,
    required this.caderno,
  });

  factory Questao.fromJson(Map<String, dynamic> json) => _$QuestaoFromJson(json);
  Map<String, dynamic> toJson() => _$QuestaoToJson(this);

  @override
  String toString() {
    return 'Questao(id: $id, titulo: $titulo, descricao: $descricao, caderno: $caderno)';
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return QuestoesDbCompanion(
      id: Value(id),
      titulo: Value(titulo),
      descricao: Value(descricao),
      tipo: Value(tipo),
      quantidadeAlternativas: Value(quantidadeAlternativas),
      caderno: Value(caderno),
    ).toColumns(nullToAbsent);
  }
}
