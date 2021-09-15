class ProvaDetalheModel {
  int? provaId;
  List<int>? questoesId;
  List<int>? arquivosId;
  List<int>? alternativasId;
  int? tamanhoTotalArquivos;

  ProvaDetalheModel({
    required this.provaId,
    required this.questoesId,
    required this.arquivosId,
    required this.alternativasId,
    required this.tamanhoTotalArquivos,
  });

  ProvaDetalheModel.fromJson(Map<String, dynamic> json) {
    provaId = json['provaId'];
    questoesId = json['questoesId'].cast<int>();
    arquivosId = json['arquivosId'].cast<int>();
    alternativasId = json['alternativasId'].cast<int>();
    tamanhoTotalArquivos = json['tamanhoTotalArquivos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provaId'] = this.provaId;
    data['questoesId'] = this.questoesId;
    data['arquivosId'] = this.arquivosId;
    data['alternativasId'] = this.alternativasId;
    data['tamanhoTotalArquivos'] = this.tamanhoTotalArquivos;
    return data;
  }
}
