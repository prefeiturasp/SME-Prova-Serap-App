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
  int modalidade;
  int inicioTurno;
  int fimTurno;

  AutenticacaoDadosResponseDTO(
    this.nome,
    this.ano,
    this.tipoTurno,
    this.tamanhoFonte,
    this.familiaFonte,
    this.modalidade,
    this.inicioTurno,
    this.fimTurno,
  );

  static const fromJson = _$AutenticacaoDadosResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AutenticacaoDadosResponseDTOToJson(this);
}
