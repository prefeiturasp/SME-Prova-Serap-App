import 'package:json_annotation/json_annotation.dart';

import 'package:appserap/enums/prova_status.enum.dart';

part 'prova.response.dto.g.dart';

@JsonSerializable()
class ProvaResponseDTO {
  int id;
  String descricao;

  int itensQuantidade;

  DateTime dataInicio;
  DateTime dataFim;

  @JsonKey(defaultValue: EnumProvaStatus.NAO_INICIADA)
  EnumProvaStatus? status;

  ProvaResponseDTO({
    required this.id,
    required this.descricao,
    required this.itensQuantidade,
    required this.dataInicio,
    required this.dataFim,
    this.status,
  });

  static const fromJson = _$ProvaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ProvaResponseDTOToJson(this);

  @override
  String toString() {
    return 'ProvaResponseDTO(id: $id, descricao: $descricao, itensQuantidade: $itensQuantidade, dataInicio: $dataInicio, dataFim: $dataFim, status: $status)';
  }
}
