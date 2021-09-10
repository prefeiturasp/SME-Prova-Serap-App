class ProvaAlternativaModel {
  int? id;
  int? questaoId;
  String? descricao;
  int? ordem;
  String? numeracao;

  ProvaAlternativaModel(
      {required this.id,
      required this.questaoId,
      required this.descricao,
      required this.ordem,
      required this.numeracao});

  ProvaAlternativaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questaoId = json['questaoId'];
    descricao = json['descricao'];
    ordem = json['ordem'];
    numeracao = json['numeracao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['questaoId'] = this.questaoId;
    data['descricao'] = this.descricao;
    data['ordem'] = this.ordem;
    data['numeracao'] = this.numeracao;
    return data;
  }
}
