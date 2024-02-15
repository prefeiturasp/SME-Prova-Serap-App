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

  @JsonValue(4)
  EM_REVISAO,

  @JsonValue(5)
  FINALIZADA_AUTOMATICAMENTE_JOB,

  @JsonValue(6)
  FINALIZADA_AUTOMATICAMENTE_TEMPO,

  @JsonValue(7)
  FINALIZADA_OFFLINE;

  bool isFinalizada() {
    return this == EnumProvaStatus.FINALIZADA ||
        this == EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE_JOB ||
        this == EnumProvaStatus.FINALIZADA_AUTOMATICAMENTE_TEMPO ||
        this == EnumProvaStatus.FINALIZADA_OFFLINE;
  }
}
