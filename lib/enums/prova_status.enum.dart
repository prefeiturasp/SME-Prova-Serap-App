import 'package:json_annotation/json_annotation.dart';

enum EnumProvaStatus {
  @JsonValue(0)
  NAO_INICIADA,

  @JsonValue(1)
  INICIADA,

  @JsonValue(2)
  FINALIZADA,

  @JsonValue(3)
  PENDENTE,
}
