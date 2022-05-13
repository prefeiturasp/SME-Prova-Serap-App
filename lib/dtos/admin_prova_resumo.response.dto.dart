import 'package:json_annotation/json_annotation.dart';

part 'admin_prova_resumo.response.dto.g.dart';

@JsonSerializable()
class AdminProvaResumoResponseDTO {
  int id;
  String? titulo;
  String? descricao;
  String caderno;
  int ordem;

  AdminProvaResumoResponseDTO({
    required this.id,
    this.titulo,
    this.descricao,
    required this.caderno,
    required this.ordem,
  });

  static const fromJson = _$AdminProvaResumoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AdminProvaResumoResponseDTOToJson(this);
}
