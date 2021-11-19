import 'package:json_annotation/json_annotation.dart';

enum EnumTipoQuestao {
  @JsonValue(0)
  NAO_CADASTRADO,

  @JsonValue(1)
  MULTIPLA_ESCOLHA,

  @JsonValue(2)
  RESPOSTA_CONTRUIDA,
}
