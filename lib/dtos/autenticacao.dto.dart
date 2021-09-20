import 'package:json_annotation/json_annotation.dart';

part 'autenticacao.dto.g.dart';

@JsonSerializable()
class AutenticacaoDTO {
  String login;
  String senha;

  AutenticacaoDTO(
    this.login,
    this.senha,
  );

  static const fromJson = _$AutenticacaoDTOFromJson;
  Map<String, dynamic> toJson() => _$AutenticacaoDTOToJson(this);
}
