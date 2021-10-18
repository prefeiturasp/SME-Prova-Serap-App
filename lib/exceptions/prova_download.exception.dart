class ProvaDownloadException implements Exception {
  int idProva;
  String mensagem;

  ProvaDownloadException(this.idProva, this.mensagem);

  @override
  String toString() {
    return "(ProvaDownloadException): [Prova ID $idProva] - $mensagem";
  }
}
