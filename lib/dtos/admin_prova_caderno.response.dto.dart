import 'package:json_annotation/json_annotation.dart';

part 'admin_prova_caderno.response.dto.g.dart';

@JsonSerializable()
class AdminProvaCadernoResponseDTO {
  List<String> cadernos;

  AdminProvaCadernoResponseDTO({
    required this.cadernos,
  });

  static const fromJson = _$AdminProvaCadernoResponseDTOFromJson;
  Map<String, dynamic> toJson() => _$AdminProvaCadernoResponseDTOToJson(this);
}
