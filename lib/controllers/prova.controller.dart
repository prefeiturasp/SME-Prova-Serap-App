import 'dart:convert';
import 'dart:typed_data';

import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/models/prova_alternativa.model.dart';
import 'package:appserap/models/prova_arquivo.model.dart';
import 'package:appserap/models/prova_completa.model.dart';
import 'package:appserap/models/prova_detalhe.model.dart';
import 'package:appserap/models/prova_questao.model.dart';
import 'package:appserap/repositories/prova.repository.dart';
import 'package:appserap/stores/download.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProvaController {
  final _provaRepository = GetIt.I.get<ProvaRepository>();
  final _dowloadStore = GetIt.I.get<DownloadStore>();
  final _provaStore = GetIt.I.get<ProvaStore>();

  Future<List<ProvaModel>> obterProvas() async {
    var retorno = await _provaRepository.obterProvas();
    return retorno;
  }

  Future<Uint8List> obterImagemPorId(String id) async {
    return _provaRepository.obterImagemPorId(id);
  }

  Future<String> obterImagemPorUrl(String? url) async {
    return _provaRepository.obterImagemPorUrl(url);
  }

  Future<ProvaDetalheModel?> obterDetalhesProva(int id) async {
    var retorno = await _provaRepository.obterProva(id);
    return retorno;
  }

  Future<ProvaArquivoModel?> obterArquivo(int arquivoId) async {
    var retorno = await _provaRepository.obterArquivo(arquivoId);
    return retorno;
  }

  Future<ProvaQuestaoModel?> obterQuestao(int questaoId) async {
    var retorno = await _provaRepository.obterQuestao(questaoId);
    return retorno;
  }

  Future<ProvaAlternativaModel?> obterAlternativa(int alternativaId) async {
    var retorno = await _provaRepository.obterAlternativa(alternativaId);
    return retorno;
  }

  void verificaConexaoComInternet() async {
    await _dowloadStore.verificaConexaoComInternet();
    _provaStore.setIconeProvaPorEstadoDeConexao(_dowloadStore.possuiConexao);
  }

  Future<void> downloadProva(ProvaModel prova, ProvaDetalheModel? detalhes) async {
    if (detalhes == null) {
      return;
    }

    var prefs = await SharedPreferences.getInstance();
    ProvaCompletaModel provaCompleta = new ProvaCompletaModel(
      id: prova.id,
      descricao: prova.descricao,
      dataFim: prova.dataInicio,
      dataInicio: prova.dataFim,
      itensQuantidade: prova.itensQuantidade,
      status: prova.status,
    );

    prefs.remove("prova_${detalhes.provaId}");
    var verificaProva = prefs.getString("prova_${detalhes.provaId}");

    _dowloadStore.totalItems =
        detalhes.arquivosId!.length + detalhes.alternativasId!.length + detalhes.questoesId!.length;

    if (verificaProva != null) {
      provaCompleta = ProvaCompletaModel.fromJson(jsonDecode(verificaProva));
    }

    if (provaCompleta.alternativas == null) {
      provaCompleta.alternativas = [];
    }

    if (provaCompleta.questoes == null) {
      provaCompleta.questoes = [];
    }

    if (provaCompleta.arquivos == null) {
      provaCompleta.arquivos = [];
    }

    var totalArquivos = detalhes.arquivosId!.length;

    for (int iArquivo = 0; iArquivo < totalArquivos; iArquivo++) {
      verificaConexaoComInternet();

      var arquivoIndex = detalhes.arquivosId![iArquivo];
      var arquivo = await obterArquivo(arquivoIndex);

      if (arquivo != null && !provaCompleta.arquivos!.contains(arquivo)) {
        arquivo.base64 = await obterImagemPorUrl(arquivo.caminho);
        provaCompleta.arquivos!.add(arquivo);
        _dowloadStore.posicaoAtual += 1;
        // print("Arquivo: ${arquivo.id}");
      }
    }

    var totalQuestoes = detalhes.questoesId!.length;
    for (var iQuestao = 0; iQuestao < totalQuestoes; iQuestao++) {
      verificaConexaoComInternet();
      var questaoIndex = detalhes.questoesId![iQuestao];

      var questao = await obterQuestao(questaoIndex);

      if (questao != null && !provaCompleta.questoes!.contains(questao)) {
        provaCompleta.questoes?.add(questao);
        _dowloadStore.posicaoAtual += 1;
        print("Questão: ${questao.id}");
      }
    }

    var totalAlternativas = detalhes.alternativasId!.length;
    for (var iAlternativa = 0; iAlternativa < totalAlternativas; iAlternativa++) {
      verificaConexaoComInternet();
      var alternativaIndex = detalhes.alternativasId![iAlternativa];

      var alternativa = await obterAlternativa(alternativaIndex);

      if (alternativa != null && !provaCompleta.alternativas!.contains(alternativa)) {
        provaCompleta.alternativas?.add(alternativa);
        _dowloadStore.posicaoAtual += 1;
        print("Alternativa: ${alternativa.id}");
      }
    }

    prefs.setString("prova_${prova.id}", jsonEncode(provaCompleta.toJson()));
    _dowloadStore.limparDownloads();
    _provaStore.prova!.status = ProvaStatusEnum.IniciarProva;

    _provaStore.iconeProva = "assets/images/prova.svg";
  }
}
