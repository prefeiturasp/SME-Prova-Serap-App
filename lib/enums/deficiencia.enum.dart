import 'package:json_annotation/json_annotation.dart';

enum DeficienciaEnum {
  @JsonValue(0)
  NAO_CADASTRADO,

  @JsonValue(1)
  SUPERDOTACAO,

  @JsonValue(2)
  AUTISMO,

  @JsonValue(5)
  SURDEZ_LEVE_OU_MODERADA,

  @JsonValue(6)
  SURDEZ_SEVERA_OU_PROFUNDA,

  @JsonValue(8)
  DEFICIENCIA_INTELECTUAL,

  @JsonValue(9)
  DEFICIENCIA_MULTIPLA,

  @JsonValue(11)
  CEGUEIRA,

  @JsonValue(12)
  BAIXA_VISAO_OU_VISAO_SUBNORMAL,

  @JsonValue(14)
  SURDOCEGUEIRA,

  @JsonValue(15)
  NAO_POSSUI,

  @JsonValue(16)
  TRANST_DESINTEGRATIVO_INFANCIA,

  @JsonValue(17)
  SINDROME_DE_ASPERGER,

  @JsonValue(18)
  SINDROME_DE_RETT,

  @JsonValue(19)
  DEFICIENCIA_FISICA_NAO_CADEIRANTE,

  @JsonValue(20)
  DEFICIENCIA_FiSICA_CADEIRANTE,
}

extension DeficienciaEnumExtension on DeficienciaEnum {
  static const nomes = {
    DeficienciaEnum.NAO_CADASTRADO: 'Não Cadastrado',
  };

  String get nome => nomes[this]!;
}

List<DeficienciaEnum> get grupoSurdos => [
      DeficienciaEnum.SURDEZ_LEVE_OU_MODERADA,
      DeficienciaEnum.SURDEZ_SEVERA_OU_PROFUNDA,
    ];

List<DeficienciaEnum> get grupoCegos => [
      DeficienciaEnum.CEGUEIRA,
      DeficienciaEnum.BAIXA_VISAO_OU_VISAO_SUBNORMAL,
    ];
