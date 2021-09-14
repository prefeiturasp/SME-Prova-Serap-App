import 'dart:convert';

import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova_alternativa.model.dart';
import 'package:appserap/models/prova_arquivo.model.dart';
import 'package:appserap/models/prova_questao.model.dart';

class ProvaCompletaModel {
  String descricao = "";
  int id = 0;
  DateTime? dataFim;
  DateTime? dataInicio;
  int itensQuantidade = 0;
  ProvaStatusEnum status = ProvaStatusEnum.Baixar;
  List<ProvaAlternativaModel>? alternativas;
  List<ProvaQuestaoModel>? questoes;
  List<ProvaArquivoModel>? arquivos;

  ProvaCompletaModel(
      {required this.id,
      required this.descricao,
      required this.dataFim,
      required this.dataInicio,
      required this.itensQuantidade,
      required this.status});

  ProvaCompletaModel.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.descricao = json['descricao'];
    this.dataFim = json['dataFim'] != "" ? DateTime.parse(json['dataFim']) : null;
    this.dataInicio = json['dataInicio'] != "" ? DateTime.parse(json['dataInicio']) : null;
    this.itensQuantidade = json['itensQuantidade'];
    this.alternativas =
        List<ProvaAlternativaModel>.from(json['alternativas']?.map((x) => ProvaAlternativaModel.fromJson(x)));

    List<ProvaQuestaoModel> questaoAux = [];
    for (var questao in json['questoes']) {
      ProvaQuestaoModel questaoNormal =
          ProvaQuestaoModel(id: 0, titulo: '', descricao: '', ordem: 0, tipo: EnumTipoQuestao.multiplaEscolha);
      questaoNormal.id = questao['id'];
      questaoNormal.titulo = questao['titulo'];
      questaoNormal.descricao = questao['descricao'];
      questaoNormal.ordem = questao['ordem'];
      questaoAux.add(questaoNormal);
    }
    this.questoes = questaoAux;

    List<ProvaArquivoModel> arquivosAux = [];
    for (var arquivo in json['arquivos']) {
      ProvaArquivoModel arquivoNormal = ProvaArquivoModel(id: 0, caminho: '', base64: '');
      arquivoNormal.id = arquivo['id'];
      arquivoNormal.caminho = arquivo['caminho'];
      arquivoNormal.base64 = arquivo['base64'];
      arquivosAux.add(arquivoNormal);
    }
    this.arquivos = arquivosAux;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['dataInicio'] = this.dataInicio.toString();
    data['dataFim'] = this.dataFim.toString();
    data['itensQuantidade'] = this.itensQuantidade;
    if (this.arquivos != null) {
      data['arquivos'] = this.arquivos!.map((v) => v.toJson()).toList();
    }
    if (this.questoes != null) {
      data['questoes'] = this.questoes!.map((v) => v.toJson()).toList();
    }
    if (this.alternativas != null) {
      data['alternativas'] = this.alternativas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
