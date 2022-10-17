import 'package:json_annotation/json_annotation.dart';

enum ModalidadeEnum {
  @JsonValue(0)
  NAO_CADASTRADO("Não Cadastrado", "NAO_CADASTRADO", 0, false),

  @JsonValue(1)
  EI("Educação Infantil", "EI", 1, true),

  @JsonValue(3)
  EJA("Educação de Jovens e Adultos", "EJA", 3, true),

  @JsonValue(4)
  CIEJA("CIEJA", "CIEJA", 4, false),

  @JsonValue(5)
  FUNDAMENTAL("Ensino Fundamental", "EF", 5, true),

  @JsonValue(6)
  MEDIO("Ensino Médio", "EM", 6, false),

  @JsonValue(7)
  CMCT("CMCT", "CMCT", 7, false),

  @JsonValue(8)
  MOVA("MOVA", "MOVA", 8, false),

  @JsonValue(9)
  ETEC("ETEC", "ETEC", 9, false);

  const ModalidadeEnum(this.nome, this.abreviacao, this.codigo, this.visivel);

  final String nome;
  final String abreviacao;
  final int codigo;
  final bool visivel;
}
