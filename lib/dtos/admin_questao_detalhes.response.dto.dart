import 'package:json_annotation/json_annotation.dart';

part 'admin_questao_detalhes.response.dto.g.dart';

@JsonSerializable()
class AdminQuestaoDetalhesResponseDTO {
  int provaId;
  int questaoId;
  List<int> arquivosId;
  List<int> alternativasId;
  List<int> audiosId;
  List<int> videosId;

  AdminQuestaoDetalhesResponseDTO({
    required this.provaId,
    required this.questaoId,
    required this.arquivosId,
    required this.alternativasId,
    required this.audiosId,
    required this.videosId,
  });

  static const fromJson = _$AdminQuestaoDetalhesResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AdminQuestaoDetalhesResponseDTOToJson(this);
}
