class AutenticarViewModel {
  String codigoEOL = "";
  String senha = "";
  bool carregando = false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.codigoEOL;
    data['senha'] = this.senha;
    return data;
  }
}
