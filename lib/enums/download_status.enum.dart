import 'package:json_annotation/json_annotation.dart';

enum EnumDownloadStatus {
  @JsonValue(0)
  NAO_INICIADO,

  @JsonValue(1)
  BAIXANDO,

  @JsonValue(2)
  PAUSADO,

  @JsonValue(3)
  CONCLUIDO,

  @JsonValue(4)
  ERRO,
}
