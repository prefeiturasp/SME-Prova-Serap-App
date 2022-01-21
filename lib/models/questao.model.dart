import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:json_annotation/json_annotation.dart';

import 'alternativa.model.dart';
import 'arquivo.model.dart';
import 'arquivo_video.model.dart';

part 'questao.model.g.dart';

@JsonSerializable()
class Questao {
  int id;
  String titulo;
  String descricao;
  int ordem;
  EnumTipoQuestao tipo;

  int quantidadeAlternativas;

  List<Alternativa> alternativas;
  List<Arquivo> arquivos;
  List<ArquivoVideo> arquivosVideos;

  Questao({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.ordem,
    required this.alternativas,
    required this.arquivos,
    required this.tipo,
    required this.quantidadeAlternativas,
    required this.arquivosVideos,
  });

  factory Questao.fromJson(Map<String, dynamic> json) => _$QuestaoFromJson(json);
  Map<String, dynamic> toJson() => _$QuestaoToJson(this);

  @override
  String toString() {
    return 'Questao(id: $id, titulo: $titulo, descricao: $descricao, ordem: $ordem, alternativas: $alternativas, arquivos: $arquivos, videos: $arquivosVideos)';
  }
}
