import 'package:json_annotation/json_annotation.dart';


enum FonteTipoEnum {
  @JsonValue(0)
  NAO_CADASTRADO,

  @JsonValue(1)
  POPPINS,

  @JsonValue(2)
  OPEN_DYSLEXIC,
}

extension FonteTipoEnumExtension on FonteTipoEnum {
  static const nomesFonte = {
    FonteTipoEnum.NAO_CADASTRADO: 'Poppins',
    FonteTipoEnum.POPPINS: 'Poppins',
    FonteTipoEnum.OPEN_DYSLEXIC: 'OpenDyslexic',
  };

  String get nomeFonte => nomesFonte[this]!;
}
