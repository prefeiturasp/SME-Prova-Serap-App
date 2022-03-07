import 'package:json_annotation/json_annotation.dart';

part 'prova.admin.response.dto.g.dart';

@JsonSerializable()
class ProvaAdminResponseDTO {
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

  ProvaAdminResponseDTO(
    this.descricao,
    this.dataInicioDownload,
    this.dataInicio,
    this.dataFim,
    this.tempoExecucao,
    this.totalItens,
    this.totalCadernos,
    this.senha,
    this.possuiBIB,
    this.id,
  );

  static const fromJson = _$ProvaAdminResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaAdminResponseDTOToJson(this);
}
