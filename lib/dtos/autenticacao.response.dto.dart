import 'package:json_annotation/json_annotation.dart';

part 'autenticacao.response.dto.g.dart';

@JsonSerializable()
class AutenticacaoResponseDTO {
  final String token;
  final DateTime dataHoraExpiracao;
  DateTime? ultimoLogin;

  AutenticacaoResponseDTO({
    required this.token,
    required this.dataHoraExpiracao,
    this.ultimoLogin 
  });

  static const fromJson = _$AutenticacaoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AutenticacaoResponseDTOToJson(this);

  @override
  String toString() => 'AutenticacaoResponseDTO(token: $token, dataHoraExpiracao: $dataHoraExpiracao)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AutenticacaoResponseDTO && other.token == token && other.dataHoraExpiracao == dataHoraExpiracao;
  }

  @override
  int get hashCode => token.hashCode ^ dataHoraExpiracao.hashCode;
}
