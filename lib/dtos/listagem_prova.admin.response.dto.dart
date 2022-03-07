import 'package:appserap/dtos/prova.admin.response.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'listagem_prova.admin.response.dto.g.dart';

@JsonSerializable()
class ListagemProvaAdminResponseDTO {
  List<ProvaAdminResponseDTO> items;
  int totalPaginas;
  int totalRegistros;

  ListagemProvaAdminResponseDTO(this.items, this.totalPaginas, this.totalRegistros);

  static const fromJson = _$ListagemProvaAdminResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$ListagemProvaAdminResponseDTOToJson(this);
}
