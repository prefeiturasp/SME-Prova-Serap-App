import 'package:json_annotation/json_annotation.dart';

part 'autenticacao_dados.response.dto.g.dart';

@JsonSerializable()
class AutenticacaoDadosResponseDTO {
  String nome;
  String ano;

  AutenticacaoDadosResponseDTO(
    this.nome,
    this.ano,
  );

  static const fromJson = _$AutenticacaoDadosResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AutenticacaoDadosResponseDTOToJson(this);
}
