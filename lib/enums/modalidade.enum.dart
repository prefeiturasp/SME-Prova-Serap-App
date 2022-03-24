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

extension ModalidadeEnumExtension on ModalidadeEnum {
  static const nomes = {
    ModalidadeEnum.NAO_CADASTRADO: 'Não Cadastrado',
    ModalidadeEnum.EI: 'Educação Infantil',
    ModalidadeEnum.EJA: 'Educação de Jovens e Adultos',
    ModalidadeEnum.CIEJA: 'CIEJA',
    ModalidadeEnum.FUNDAMENTAL: 'Ensino Fundamental',
    ModalidadeEnum.MEDIO: 'Ensino Médio',
    ModalidadeEnum.CMCT: 'CMCT',
    ModalidadeEnum.MOVA: 'MOVA',
    ModalidadeEnum.ETEC: 'ETEC',
  };

  String get nome => nomes[this]!;

  static const abreviacoes = {
    ModalidadeEnum.NAO_CADASTRADO: 'NAO_CADASTRADO',
    ModalidadeEnum.EI: 'EI',
    ModalidadeEnum.EJA: 'EJA',
    ModalidadeEnum.CIEJA: 'CIEJA',
    ModalidadeEnum.FUNDAMENTAL: 'EF',
    ModalidadeEnum.MEDIO: 'EM',
    ModalidadeEnum.CMCT: 'CMCT',
    ModalidadeEnum.MOVA: 'MOVA',
    ModalidadeEnum.ETEC: 'ETEC',
  };

  String get abreviacao => abreviacoes[this]!;

  static const codigos = {
    ModalidadeEnum.NAO_CADASTRADO: 0,
    ModalidadeEnum.EI: 1,
    ModalidadeEnum.EJA: 3,
    ModalidadeEnum.CIEJA: 4,
    ModalidadeEnum.FUNDAMENTAL: 5,
    ModalidadeEnum.MEDIO: 6,
    ModalidadeEnum.CMCT: 7,
    ModalidadeEnum.MOVA: 8,
    ModalidadeEnum.ETEC: 9,
  };

  int get codigo => codigos[this]!;
}
