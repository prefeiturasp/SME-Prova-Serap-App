enum EnumDownloadTipo {
  QUESTAO,
  ARQUIVO,
  ALTERNATIVA,
  CONTEXTO_PROVA,
  VIDEO,
  AUDIO,
}

extension EnumDownloadTipoExtension on EnumDownloadTipo {
  static const orderValues = {
    EnumDownloadTipo.QUESTAO: 1,
    EnumDownloadTipo.ALTERNATIVA: 2,
    EnumDownloadTipo.CONTEXTO_PROVA: 3,
    EnumDownloadTipo.ARQUIVO: 4,
    EnumDownloadTipo.VIDEO: 5,
    EnumDownloadTipo.AUDIO: 6,
  };

  int get order => orderValues[this]!;
}
