import 'package:json_annotation/json_annotation.dart';

part 'data_hora_servidor.response.dto.g.dart';

@JsonSerializable()
class DataHoraServidorDTO {
  DateTime dataHora;
  int tolerancia;

  DataHoraServidorDTO(
    this.dataHora,
    this.tolerancia,
  );

  static const fromJson = _$DataHoraServidorDTOFromJson;
  Map<String, dynamic> toJson() => _$DataHoraServidorDTOToJson(this);
}
