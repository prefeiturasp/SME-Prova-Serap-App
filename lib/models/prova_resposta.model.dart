class ProvaRespostaModel {
  int provaId = 0;
  int questaoId = 0;
  int? alternativaId;
  String? resposta;
  bool sincronizada = false;

  ProvaRespostaModel({
    required this.provaId,
    required this.questaoId,
    required this.alternativaId,
    required this.resposta,
    required this.sincronizada,
  });

  ProvaRespostaModel.fromJson(Map<String, dynamic> json) {
    provaId = json['provaId'];
    questaoId = json['questaoId'];
    alternativaId = json['alternativaId'] != null ? json['alternativaId'] : 0;
    resposta = json['resposta'] != null ? json['resposta'] : "";
    sincronizada = json['sincronizada'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provaId'] = this.provaId;
    data['questaoId'] = this.questaoId;
    data['alternativaId'] = this.alternativaId;
    data['resposta'] = this.resposta;
    data['sincronizada'] = this.sincronizada;
    return data;
  }
}
