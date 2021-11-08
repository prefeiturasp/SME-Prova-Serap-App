import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'autenticacao_dados.response.dto.g.dart';

@JsonSerializable()
class AutenticacaoDadosResponseDTO {
  String nome;
  String ano;
  String tipoTurno;
  double tamanhoFonte;
  FonteTipoEnum familiaFonte;

  AutenticacaoDadosResponseDTO(
    this.nome,
    this.ano,
    this.tipoTurno,
    this.tamanhoFonte,
    this.familiaFonte,
  );

  static const fromJson = _$AutenticacaoDadosResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AutenticacaoDadosResponseDTOToJson(this);
}
