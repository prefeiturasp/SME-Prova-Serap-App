import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'questao_detalhes_legado.response.dto.g.dart';

@JsonSerializable()
class QuestaoDetalhesLegadoResponseDTO {
  int id;
  String? titulo;
  String descricao;
  int ordem;
  EnumTipoQuestao tipo;
  int quantidadeAlternativas;

  QuestaoDetalhesLegadoResponseDTO({
    required this.id,
    this.titulo,
    required this.descricao,
    required this.ordem,
    required this.tipo,
    required this.quantidadeAlternativas,
  });

  static const fromJson = _$QuestaoDetalhesLegadoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$QuestaoDetalhesLegadoResponseDTOToJson(this);

  @override
  String toString() {
    return 'QuestaoDetalhesLegadoResponseDTO(id: $id, titulo: $titulo, descricao: $descricao, ordem: $ordem, tipo: $tipo)';
  }
}
