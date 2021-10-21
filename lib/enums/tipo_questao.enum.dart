import 'package:json_annotation/json_annotation.dart';

enum EnumTipoQuestao {
  @JsonValue(0)
  NAO_CADASTRADO,

  @JsonValue(1)
  MULTIPLA_ESCOLHA_4,

  @JsonValue(2)
  MULTIPLA_ESCOLHA_5,

  @JsonValue(3)
  RESPOSTA_CONTRUIDA,

}
