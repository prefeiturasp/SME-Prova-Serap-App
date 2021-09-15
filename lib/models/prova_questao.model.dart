import 'package:appserap/models/prova_alternativa.model.dart';

enum EnumTipoQuestao { multiplaEscolha, descritiva }

class ProvaQuestaoModel {
  int? id;
  String? titulo;
  String? descricao;
  int? ordem;
  List<ProvaAlternativaModel>? alternativas;
  EnumTipoQuestao? tipo;

  ProvaQuestaoModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.ordem,
    required this.tipo,
  });

  ProvaQuestaoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    descricao = json['descricao'];
    ordem = json['ordem'];
    alternativas = json['alternativas'] != null ? json['alternativas'].cast<ProvaAlternativaModel>() : [];
    tipo = EnumTipoQuestao.values[json['tipo'] ?? 0];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['descricao'] = this.descricao;
    data['ordem'] = this.ordem;
    data['tipo'] = this.tipo?.index ?? 0;

    return data;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}
