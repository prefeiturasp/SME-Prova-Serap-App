import 'package:appserap/models/prova_alternativa.model.dart';

class ProvaQuestaoModel {
  int? id;
  String? titulo;
  String? descricao;
  int? ordem;
  List<ProvaAlternativaModel>? alternativas;

  ProvaQuestaoModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.ordem,
  });

  ProvaQuestaoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    descricao = json['descricao'];
    ordem = json['ordem'];
    alternativas = json['alternativas'] != null
        ? json['alternativas'].cast<ProvaAlternativaModel>()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['descricao'] = this.descricao;
    data['ordem'] = this.ordem;
    return data;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}
