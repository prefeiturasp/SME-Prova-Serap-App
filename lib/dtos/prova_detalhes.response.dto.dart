import 'package:json_annotation/json_annotation.dart';

part 'prova_detalhes.response.dto.g.dart';

@JsonSerializable()
class ProvaDetalhesResponseDTO {
  int provaId;
  List<int> questoesId;
  List<int> arquivosId;
  List<int> alternativasId;
  int tamanhoTotalArquivos;

  ProvaDetalhesResponseDTO({
    required this.provaId,
    required this.questoesId,
    required this.arquivosId,
    required this.alternativasId,
    required this.tamanhoTotalArquivos,
  });

  static const fromJson = _$ProvaDetalhesResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaDetalhesResponseDTOToJson(this);

  @override
  String toString() {
    return 'ProvaDetalhesResponseDTO(provaId: $provaId, questoesId: $questoesId, arquivosId: $arquivosId, alternativasId: $alternativasId, tamanhoTotalArquivos: $tamanhoTotalArquivos)';
  }
}