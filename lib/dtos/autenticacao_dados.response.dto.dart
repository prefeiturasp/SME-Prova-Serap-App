import 'package:json_annotation/json_annotation.dart';

part 'autenticacao_dados.response.dto.g.dart';

@JsonSerializable()
class AutenticacaoDadosResponseDTO {
  String nome;
  String ano;
  String tipoTurno;

  AutenticacaoDadosResponseDTO(
    this.nome,
    this.ano,
    this.tipoTurno,
  );

  static const fromJson = _$AutenticacaoDadosResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AutenticacaoDadosResponseDTOToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AutenticacaoDadosResponseDTO &&
        other.nome == nome &&
        other.ano == ano &&
        other.tipoTurno == tipoTurno;
  }

  @override
  int get hashCode => nome.hashCode ^ ano.hashCode ^ tipoTurno.hashCode;
}
