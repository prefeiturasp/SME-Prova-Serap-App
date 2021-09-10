class TokenModel {
  String token = "";
  String dataHoraExpiracao = "";

  TokenModel({required this.token, required this.dataHoraExpiracao});

  TokenModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    dataHoraExpiracao = json['dataHoraExpiracao'];
  }
}
