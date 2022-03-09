import 'package:appserap/dtos/admin_prova.response.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'listagem_prova.admin.response.dto.g.dart';

@JsonSerializable()
class ListagemAdminProvaResponseDTO {
  List<AdminProvaResponseDTO> items;
  int totalPaginas;
  int totalRegistros;

  ListagemAdminProvaResponseDTO(this.items, this.totalPaginas, this.totalRegistros);

  static const fromJson = _$ListagemAdminProvaResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ListagemAdminProvaResponseDTOToJson(this);
}
