import 'package:json_annotation/json_annotation.dart';

enum EnumTipoDispositivo {
  @JsonValue(1)
  mobile,

  @JsonValue(2)
  tablet,

  @JsonValue(3)
  web,
}
