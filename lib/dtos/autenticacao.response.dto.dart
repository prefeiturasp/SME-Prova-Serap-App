import 'package:json_annotation/json_annotation.dart';

part 'autenticacao.response.dto.g.dart';

@JsonSerializable()
class AutenticacaoResponseDTO {
  final String token;
  final DateTime dataHoraExpiracao;

  AutenticacaoResponseDTO({
    required this.token,
    required this.dataHoraExpiracao,
  });

  static const fromJson = _$AutenticacaoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AutenticacaoResponseDTOToJson(this);

  @override
  String toString() => 'AutenticacaoResponseDTO(token: $token, dataHoraExpiracao: $dataHoraExpiracao)';
}
