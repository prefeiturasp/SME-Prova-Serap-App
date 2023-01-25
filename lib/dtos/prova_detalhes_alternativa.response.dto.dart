import 'package:json_annotation/json_annotation.dart';

part 'prova_detalhes_alternativa.response.dto.g.dart';

@JsonSerializable()
class ProvaDetalhesAlternativaResponseDTO {
  int alternativaId;
  int alternativaLegadoId;
  int ordem;

  ProvaDetalhesAlternativaResponseDTO({
    required this.alternativaId,
    required this.alternativaLegadoId,
    required this.ordem,
  });

  static const fromJson = _$ProvaDetalhesAlternativaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaDetalhesAlternativaResponseDTOToJson(this);
}
