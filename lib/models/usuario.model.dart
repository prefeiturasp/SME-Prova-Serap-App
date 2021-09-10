class UsuarioModel {
  String nome = "";
  String ano = "";

  UsuarioModel({required this.nome, required this.ano});

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    ano = json['ano'];
  }
}
