import 'package:json_annotation/json_annotation.dart';

part 'orientacao_inicial.response.dto.g.dart';

@JsonSerializable()
class OrientacaoInicialResponseDTO {

  int? id;
  String? descricao;
  int? ordem;
  String? titulo;
  String? imagem;

  OrientacaoInicialResponseDTO({
    this.id,
    this.descricao,
    this.ordem,
    this.titulo,
    this.imagem,
  });

  static const fromJson = _$OrientacaoInicialResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$OrientacaoInicialResponseDTOToJson(this);

  @override
  String toString() {
    return fromJson.toString();
  }
}
