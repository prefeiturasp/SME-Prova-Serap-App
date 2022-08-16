import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:json_annotation/json_annotation.dart';

import 'alternativa.response.dto.dart';
import 'arquivo.response.dto.dart';
import 'arquivo_video.response.dto.dart';

part 'questao_detalhes_legado.response.dto.g.dart';

@JsonSerializable()
class QuestaoDetalhesLegadoResponseDTO {
  int id;
  int questaoLegadoId;
  String? titulo;
  String descricao;
  EnumTipoQuestao tipo;
  int quantidadeAlternativas;

  List<ArquivoResponseDTO> arquivos;
  List<ArquivoResponseDTO> audios;
  List<ArquivoVideoResponseDTO> videos;

  List<AlternativaResponseDTO> alternativas;

  QuestaoDetalhesLegadoResponseDTO({
    required this.id,
    required this.questaoLegadoId,
    this.titulo,
    required this.descricao,
    required this.tipo,
    required this.quantidadeAlternativas,
    required this.arquivos,
    required this.audios,
    required this.videos,
    required this.alternativas,
  });

  static const fromJson = _$QuestaoDetalhesLegadoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$QuestaoDetalhesLegadoResponseDTOToJson(this);
}
