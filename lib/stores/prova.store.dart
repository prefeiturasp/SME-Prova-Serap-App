import 'dart:convert';

import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/prova_alternativa.model.dart';
import 'package:appserap/models/prova_arquivo.model.dart';
import 'package:appserap/models/prova_completa.model.dart';
import 'package:appserap/models/prova_detalhe.model.dart';
import 'package:appserap/models/prova_questao.model.dart';
import 'package:appserap/models/prova_resposta.model.dart';
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
  ProvaStatusEnum status = ProvaStatusEnum.Baixar;

  @observable
  String iconeProva = "assets/images/prova.svg";

  @observable
  bool baixando = false;

  @observable
  int questaoAtual = 1;

  @observable
  int? resposta = 1;

  @action
  Future<void> adicionarResposta(int questaoId, int alternativaId) async {
    var prefs = await SharedPreferences.getInstance();
    List<ProvaRespostaModel> respostas = [];

    var provaRespostasJson = prefs.getString("prova_respostas_${prova!.id}");

    if (provaRespostasJson != null) {
      respostas = (jsonDecode(provaRespostasJson) as List)
          .map((x) => ProvaRespostaModel.fromJson(x))
          .toList();
    }

    if (respostas.length > 0) {
      respostas.removeWhere((resposta) => resposta.questaoId == questaoId);
    }

    respostas.add(
      new ProvaRespostaModel(
          provaId: prova!.id,
          questaoId: questaoId,
          alternativaId: alternativaId,
          resposta: "",
          sincronizada: false),
    );

    prefs.setString(
      "prova_respostas_${prova!.id}",
      jsonEncode(respostas),
    );

    // print("Prova ${prova!.id}");
    // print("Questão $questaoId");
    // print("Alternativa $alternativaId");
  }

  @action
  void setIconeProvaPorEstadoDeConexao(bool possuiConexao) {
    possuiConexao
        ? iconeProva = "assets/images/prova_download.svg"
        : iconeProva = "assets/images/prova_erro_download.svg";
  }

  @observable
  String mensagemDownload = "";

  @action
  void setMensagemDownload(String mensagem) => mensagemDownload = mensagem;

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
  carregarProvaCompletaStorage(int id) async {
    var prefs = await SharedPreferences.getInstance();
    var provaStorage = prefs.getString("prova_completa_$id");
    if (provaStorage != null) {
      this.provaCompleta =
          ProvaCompletaModel.fromJson(jsonDecode(provaStorage));
      if (verificaSeProvaCompleta()) {
        this.prova!.status = ProvaStatusEnum.IniciarProva;
        this.status = ProvaStatusEnum.IniciarProva;
      }
    }
  }

  bool verificaSeProvaCompleta() {
    return true;
  }

  @action
  carregarProvaDetalhes(ProvaDetalheModel provaDetalhes) {
    this.detalhes = provaDetalhes;
  }

  @action
  alterarStatus(ProvaStatusEnum status) {
    this.prova!.status = status;
    this.status = status;
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
