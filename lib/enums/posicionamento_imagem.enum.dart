import 'package:json_annotation/json_annotation.dart';


enum PosicionamentoImagemEnum {
  @JsonValue(0)
  NAO_CADASTRADO,

  @JsonValue(1)
  DIREITA,

  @JsonValue(2)
  CENTRO,

  @JsonValue(3)
  ESQUERDA,
}

extension PosicionamentoImagemEnumExtension on PosicionamentoImagemEnum {
  static const posicoesImagem = {
    PosicionamentoImagemEnum.NAO_CADASTRADO: 'Não Cadastrado',
    PosicionamentoImagemEnum.DIREITA: 'Direita',
    PosicionamentoImagemEnum.CENTRO: 'Centro',
    PosicionamentoImagemEnum.ESQUERDA: 'Esquerda',
  };

  String get posicaoImagem => posicoesImagem[this]!;
}
