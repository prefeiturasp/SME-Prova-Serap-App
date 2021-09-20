import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:json_annotation/json_annotation.dart';

import 'alternativa.model.dart';
import 'arquivo.model.dart';

part 'questao.model.g.dart';

@JsonSerializable()
class Questao {
  int id;
  String titulo;
  String descricao;
  int ordem;
  EnumTipoQuestao tipo;

  List<Alternativa> alternativas;
  List<Arquivo> arquivos;

  Questao({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.ordem,
    required this.alternativas,
    required this.arquivos,
    this.tipo = EnumTipoQuestao.multiplaEscolha,
  });

  factory Questao.fromJson(Map<String, dynamic> json) => _$QuestaoFromJson(json);
  Map<String, dynamic> toJson() => _$QuestaoToJson(this);

  @override
  String toString() {
    return 'Questao(id: $id, titulo: $titulo, descricao: $descricao, ordem: $ordem, alternativas: $alternativas, arquivos: $arquivos)';
  }
}
