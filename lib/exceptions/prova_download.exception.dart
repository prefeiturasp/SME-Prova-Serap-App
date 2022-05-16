class ProvaDownloadException implements Exception {
  int idProva;
  String mensagem;

  ProvaDownloadException(this.idProva, this.mensagem);

  int get getIdProva => idProva;

  @override
  String toString() {
    return mensagem;
  }
}
