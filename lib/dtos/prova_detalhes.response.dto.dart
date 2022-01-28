import 'package:json_annotation/json_annotation.dart';

part 'prova_detalhes.response.dto.g.dart';

@JsonSerializable()
class ProvaDetalhesResponseDTO {
  int provaId;
  List<int> questoesId;
  List<int> arquivosId;
  List<int> videosId;
  List<int> audiosId;
  List<int> alternativasId;
  int tamanhoTotalArquivos;
  List<int> contextoProvaIds;

  ProvaDetalhesResponseDTO({
    required this.provaId,
    required this.questoesId,
    required this.arquivosId,
    this.videosId = const [],
    this.audiosId = const [],
    required this.alternativasId,
    required this.tamanhoTotalArquivos,
    required this.contextoProvaIds,
  });

  static const fromJson = _$ProvaDetalhesResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaDetalhesResponseDTOToJson(this);

  @override
  String toString() {
    return 'ProvaDetalhesResponseDTO(provaId: $provaId, questoesId: $questoesId, arquivosId: $arquivosId, videosId: $videosId, audiosId: $audiosId, alternativasId: $alternativasId, tamanhoTotalArquivos: $tamanhoTotalArquivos)';
  }
}
