import 'package:json_annotation/json_annotation.dart';

part 'prova_detalhes_alternativa.response.dto.g.dart';

@JsonSerializable()
class ProvaDetalhesAlternativaResponseDTO {
  int id;
  int legadoId;

  ProvaDetalhesAlternativaResponseDTO({
    required this.id,
    required this.legadoId,
  });

  static const fromJson = _$ProvaDetalhesAlternativaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaDetalhesAlternativaResponseDTOToJson(this);
}
