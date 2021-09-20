import 'package:json_annotation/json_annotation.dart';

part 'prova.response.dto.g.dart';

@JsonSerializable()
class ProvaResponseDTO {
  int id;
  String descricao;
  int itensQuantidade;
  DateTime dataInicio;
  DateTime dataFim;

  ProvaResponseDTO({
    required this.id,
    required this.descricao,
    required this.itensQuantidade,
    required this.dataInicio,
    required this.dataFim,
  });

  @override
  String toString() {
    return 'ProvaResponseDTO(id: $id, descricao: $descricao, itensQuantidade: $itensQuantidade, dataInicio: $dataInicio, dataFim: $dataFim)';
  }

  static const fromJson = _$ProvaResponseDTOFromJson;

  Map<String, dynamic> toJson() => _$ProvaResponseDTOToJson(this);
}
