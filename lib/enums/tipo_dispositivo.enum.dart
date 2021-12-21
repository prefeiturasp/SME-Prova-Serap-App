import 'package:json_annotation/json_annotation.dart';

enum EnumTipoDispositivo {
  @JsonValue(0)
  NAO_CADASTRADO,

  @JsonValue(1)
  MOBILE,

  @JsonValue(2)
  TABLET,

  @JsonValue(3)
  WEB,
}
