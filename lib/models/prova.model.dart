import 'package:appserap/enums/prova_status.enum.dart';

class ProvaModel {
  String descricao = "";
  int id = 0;
  DateTime? dataFim;
  DateTime? dataInicio;
  int itensQuantidade = 0;
  ProvaStatusEnum status = ProvaStatusEnum.Baixar;

  ProvaModel(
      {required this.id,
      required this.descricao,
      required this.dataFim,
      required this.dataInicio,
      required this.itensQuantidade,
      required this.status});

  ProvaModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.descricao = json['descricao'];
    this.dataFim =
        json['dataFim'] != "" ? DateTime.parse(json['dataFim']) : null;
    this.dataInicio =
        json['dataInicio'] != "" ? DateTime.parse(json['dataInicio']) : null;
    this.itensQuantidade = json['itensQuantidade'];
  }
}
