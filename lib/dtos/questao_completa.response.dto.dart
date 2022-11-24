import 'package:appserap/dtos/questao.response.dto.dart';
import 'package:appserap/enums/tipo_questao.enum.dart';
import 'package:json_annotation/json_annotation.dart';

import 'alternativa.response.dto.dart';
import 'arquivo.response.dto.dart';
import 'arquivo_video.response.dto.dart';

part 'questao_completa.response.dto.g.dart';

@JsonSerializable()
class QuestaoCompletaResponseDTO {
  int id;
  String? titulo;
  String descricao;
  int ordem;
  EnumTipoQuestao tipo;
  int quantidadeAlternativas;

  List<ArquivoResponseDTO> arquivos;
  List<ArquivoResponseDTO> audios;
  List<ArquivoVideoResponseDTO> videos;

  List<AlternativaResponseDTO> alternativas;

  QuestaoCompletaResponseDTO({
    required this.id,
    this.titulo,
    required this.descricao,
    required this.ordem,
    required this.tipo,
    required this.quantidadeAlternativas,
    required this.arquivos,
    required this.audios,
    required this.videos,
    required this.alternativas,
  });

  static const fromJson = _$QuestaoCompletaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$QuestaoCompletaResponseDTOToJson(this);

  QuestaoResponseDTO getQuestaoResponseDTO() {
    return QuestaoResponseDTO(
      id: id,
      descricao: descricao,
      titulo: titulo,
      ordem: ordem,
      tipo: tipo,
      quantidadeAlternativas: quantidadeAlternativas,
    );
  }

  @override
  String toString() {
    return """ QuestaoResponseDTO {
    id: $id,
    titulo: $titulo,
    descricao: $descricao,
    ordem: $ordem,
    tipo: $tipo,
    quantidadeAlternativas: $quantidadeAlternativas,
    arquivos: $arquivos,
    audios: $audios,
    videos: $videos,
    alternativas: $alternativas,
  }""";
  }
}
