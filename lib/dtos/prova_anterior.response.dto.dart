import 'package:appserap/enums/prova_status.enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prova_anterior.response.dto.g.dart';

@JsonSerializable()
class ProvaAnteriorResponseDTO {
  int id;
  String descricao;

  int itensQuantidade;

  DateTime dataInicio;
  DateTime? dataFim;

  int tempoTotal;

  EnumProvaStatus status;

  DateTime? dataInicioProvaAluno;
  DateTime? dataFimProvaAluno;

  ProvaAnteriorResponseDTO({
    required this.id,
    required this.descricao,
    required this.itensQuantidade,
    required this.dataInicio,
    this.dataFim,
    required this.tempoTotal,
    required this.status,
    required this.dataInicioProvaAluno,
    required this.dataFimProvaAluno,
  });

  static const fromJson = _$ProvaAnteriorResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaAnteriorResponseDTOToJson(this);
}
