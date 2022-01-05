enum EnumDownloadTipo {
  QUESTAO,
  ARQUIVO,
  ALTERNATIVA,
  CONTEXTO_PROVA,
  VIDEO,
}

extension EnumDownloadTipoExtension on EnumDownloadTipo {
  static const orderValues = {
    EnumDownloadTipo.QUESTAO: 1,
    EnumDownloadTipo.ALTERNATIVA: 2,
    EnumDownloadTipo.CONTEXTO_PROVA: 3,
    EnumDownloadTipo.ARQUIVO: 4,
    EnumDownloadTipo.VIDEO: 5,
  };

  int get order => orderValues[this]!;
}
