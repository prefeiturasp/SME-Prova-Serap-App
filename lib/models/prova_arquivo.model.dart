class ProvaArquivoModel {
  int? id;
  String? caminho;
  String base64 = "";

  ProvaArquivoModel(
      {required this.id, required this.caminho, required this.base64});

  ProvaArquivoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    caminho = json['caminho'];
    base64 = json['base64'] != null ? json['base64'] : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['caminho'] = this.caminho;
    data['base64'] = this.base64;
    return data;
  }
}
