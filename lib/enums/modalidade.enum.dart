import 'package:json_annotation/json_annotation.dart';

enum ModalidadeEnum {
  @JsonValue(0)
  NAO_CADASTRADO,

  @JsonValue(1)
  EI,

  @JsonValue(3)
  EJA,

  @JsonValue(4)
  CIEJA,

  @JsonValue(5)
  FUNDAMENTAL,

  @JsonValue(6)
  MEDIO,

  @JsonValue(7)
  CMCT,

  @JsonValue(8)
  MOVA,

  @JsonValue(9)
  ETEC
}
