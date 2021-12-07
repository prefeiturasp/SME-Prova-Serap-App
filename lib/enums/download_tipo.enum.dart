enum EnumDownloadTipo { QUESTAO, ARQUIVO, ALTERNATIVA, CONTEXTO_PROVA }

extension EnumDownloadTipoExtension on EnumDownloadTipo {
  static const orderValues = {
    EnumDownloadTipo.QUESTAO: 1,
    EnumDownloadTipo.ALTERNATIVA: 2,
    EnumDownloadTipo.CONTEXTO_PROVA: 3,
    EnumDownloadTipo.ARQUIVO: 4,
  };

  int get order => orderValues[this]!;
}
