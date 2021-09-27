import 'package:json_annotation/json_annotation.dart';

enum EnumTipoQuestao {
  @JsonValue(0)
  MULTIPLA_ESCOLHA,

  @JsonValue(1)
  RESPOSTA_CONTRUIDA,
}
