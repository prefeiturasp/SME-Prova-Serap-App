class AutenticacaoDTO {
  String codigoEOL = "";
  String senha = "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.codigoEOL;
    data['senha'] = this.senha;
    return data;
  }
}
