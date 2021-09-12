import 'dart:convert';

import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/prova_alternativa.model.dart';
import 'package:appserap/models/prova_arquivo.model.dart';
import 'package:appserap/models/prova_completa.model.dart';
import 'package:appserap/models/prova_detalhe.model.dart';
import 'package:appserap/models/prova_questao.model.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prova.store.g.dart';

class ProvaStore = _ProvaStoreBase with _$ProvaStore;

abstract class _ProvaStoreBase with Store {
  @observable
  String mensagem = "";

  @observable
  ProvaModel? prova;

  @observable
  ProvaCompletaModel? provaCompleta;

  @observable
  ProvaDetalheModel? detalhes;

  @observable
  List<ProvaArquivoModel> arquivos = [];

  @observable
  List<ProvaQuestaoModel> questoes = [];

  @observable
  List<ProvaAlternativaModel> alternativas = [];

  @observable
  String iconeProva = "assets/images/prova.svg";

  @observable
  int questaoAtual = 1;

  @observable
  int? resposta = 1;

  @action
  void setIconeProvaPorEstadoDeConexao(bool possuiConexao) {
    possuiConexao
        ? iconeProva = "assets/images/prova_download.svg"
        : iconeProva = "assets/images/prova_erro_download.svg";
  }

  @action
  Future<void> carregarMensagem() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString("testeMensagem") != null) {
      mensagem = prefs.getString("testeMensagem")!;
    }
  }

  @action
  Future<void> atualizarMensagem(String msg) async {
    var prefs = await SharedPreferences.getInstance();
    this.mensagem = msg;

    prefs.setString("testeMensagem", msg);
  }

  @action
  carregarProva(ProvaModel prova) {
    this.prova = prova;
  }

  @action
  carregarProvaStorage(int id) async {
    var prefs = await SharedPreferences.getInstance();
    var provaStorage = prefs.getString("prova_$id");
    if (provaStorage != null) {
      this.provaCompleta = ProvaCompletaModel.fromJson(jsonDecode(provaStorage));
    }
  }

  @action
  carregarProvaDetalhes(ProvaDetalheModel provaDetalhes) {
    this.detalhes = provaDetalhes;
  }

  @action
  alterarStatus(ProvaStatusEnum status) {
    this.prova!.status = status;
  }

  @action
  adicionarArquivo(ProvaArquivoModel arquivo) {
    this.arquivos.add(arquivo);
  }

  @action
  adicionarQuestao(ProvaQuestaoModel arquivo) {
    this.questoes.add(arquivo);
  }

  @action
  adicionarAlternativa(ProvaAlternativaModel alternativa) {
    this.alternativas.add(alternativa);
  }

  @action
  Future<void> limparProvas() async {
    this.prova = null;
    this.detalhes = null;
    this.arquivos = [];
    this.questoes = [];
    this.alternativas = [];
    // await prefs.clear();
  }
}
