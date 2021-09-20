class ProvaRespostaDTO {
  int questaoId = 0;
  int resposta = 0;

  ProvaRespostaDTO({
    required this.questaoId,
    required this.resposta,
  });

  ProvaRespostaDTO.fromJson(Map<String, dynamic> json) {
    questaoId = json['questaoId'];
    resposta = json['resposta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questaoId'] = this.questaoId;
    data['resposta'] = this.resposta;
    return data;
  }
}
