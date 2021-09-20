class ProvaArquivoDTO {
  int? id;
  String? caminho;
  String base64 = "";
  int tamanho = 0;

  ProvaArquivoDTO({
    required this.id,
    required this.caminho,
    required this.base64,
    required this.tamanho,
  });

  ProvaArquivoDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    caminho = json['caminho'];
    base64 = json['base64'] != null ? json['base64'] : "";
    tamanho = json['tamanho'] != null ? json['tamanho'] : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['caminho'] = this.caminho;
    data['base64'] = this.base64;
    data['tamanho'] = this.tamanho;
    return data;
  }
}
