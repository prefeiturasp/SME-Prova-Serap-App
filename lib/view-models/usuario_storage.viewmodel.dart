class UsuarioStorageViewModel {
  String codigoEOL = "";
  String token = "";
  String nome = "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigoEOL'] = this.codigoEOL;
    data['token'] = this.token;
    data['nome'] = this.nome;
    return data;
  }
}
