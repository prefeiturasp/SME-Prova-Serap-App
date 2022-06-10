import 'package:json_annotation/json_annotation.dart';

part 'versao_dispositivo.dto.g.dart';

@JsonSerializable()
class VersaoDispositivoDto {
  int versaoCodigo;
  String versaoDescricao;
  String dispositivoImei;
  DateTime atualizadoEm;

  VersaoDispositivoDto({
    required this.versaoCodigo,
    required this.versaoDescricao,
    required this.dispositivoImei,
    required this.atualizadoEm,
  });

  static const fromJson = _$VersaoDispositivoDtoFromJson;
  Map<String, dynamic> toJson() => _$VersaoDispositivoDtoToJson(this);
}
