import 'package:json_annotation/json_annotation.dart';

part 'admin_prova.response.dto.g.dart';

@JsonSerializable()
class AdminProvaResponseDTO {
  int id;

  String descricao;

  DateTime? dataInicioDownload;
  DateTime dataInicio;
  DateTime? dataFim;

  int tempoExecucao;

  int totalItens;

  bool possuiBIB;
  int totalCadernos;

  String? senha;

  bool possuiContexto;

  AdminProvaResponseDTO({
    required this.id,
    required this.descricao,
    this.dataInicioDownload,
    required this.dataInicio,
    this.dataFim,
    required this.tempoExecucao,
    required this.totalItens,
    required this.totalCadernos,
    this.senha,
    required this.possuiBIB,
    required this.possuiContexto,
  });

  static const fromJson = _$AdminProvaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AdminProvaResponseDTOToJson(this);
}
