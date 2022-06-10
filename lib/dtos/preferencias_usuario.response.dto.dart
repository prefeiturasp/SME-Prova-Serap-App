import 'package:appserap/enums/fonte_tipo.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preferencias_usuario.response.dto.g.dart';

@JsonSerializable()
class PreferenciasUsuarioResponseDTO {
  double tamanhoFonte;
  FonteTipoEnum familiaFonte;

  PreferenciasUsuarioResponseDTO(
    this.tamanhoFonte,
    this.familiaFonte,
  );

  static const fromJson = _$PreferenciasUsuarioResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$PreferenciasUsuarioResponseDTOToJson(this);
}
