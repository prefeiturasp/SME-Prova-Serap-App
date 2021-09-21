import 'package:json_annotation/json_annotation.dart';

import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/download_tipo.enum.dart';

part 'download_prova.model.g.dart';

@JsonSerializable()
class DownloadProva {
  int id;
  EnumDownloadTipo tipo;
  EnumDownloadStatus downloadStatus;
  DateTime dataHoraInicio;

  DownloadProva({
    required this.id,
    required this.tipo,
    this.downloadStatus = EnumDownloadStatus.NAO_INICIADO,
    required this.dataHoraInicio,
  });

  factory DownloadProva.fromJson(Map<String, dynamic> json) => _$DownloadProvaFromJson(json);
  Map<String, dynamic> toJson() => _$DownloadProvaToJson(this);

  @override
  String toString() {
    return 'DownloadProva(id: $id, tipo: $tipo, downloadStatus: $downloadStatus, dataHoraInicio: $dataHoraInicio)';
  }
}
