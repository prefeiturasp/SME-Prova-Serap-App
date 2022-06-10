class SemConexaoException implements Exception {
  SemConexaoException();

  @override
  String toString() {
    return "Sem conexão com a internet";
  }
}
