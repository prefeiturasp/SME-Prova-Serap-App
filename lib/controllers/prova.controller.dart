import 'dart:convert';
import 'dart:typed_data';

import 'package:appserap/dtos/arquivo_metadata.dto.dart';
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
  final _downloadStore = GetIt.I.get<DownloadStore>();
  final _provaStore = GetIt.I.get<ProvaStore>();

  Future<List<ProvaModel>> obterProvas() async {
    var retorno = await _provaRepository.obterProvas();
    return retorno;
  }

  Future<Uint8List> obterImagemPorId(String id) async {
    return _provaRepository.obterImagemPorId(id);
  }

  Future<ArquivoMetadataDTO> obterImagemPorUrlV2(String? url) async {
    return _provaRepository.obterImagemPorUrlV2(url);
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

  // void verificaConexaoComInternet() async {

  //   _provaStore.setIconeProvaPorEstadoDeConexao(_downloadStore.possuiConexao);
  //   if (!_downloadStore.possuiConexao &&
  //       _downloadStore.progressoDownload >= 0) {
  //     _provaStore.setMensagemDownload(
  //       "Pausado em ${(_downloadStore.progressoDownload * 100).toStringAsFixed(2)}% - Sem conexão com a internet",
  //     );
  //     _provaStore.prova!.status = ProvaStatusEnum.DownloadPausado;
  //   } else if (!_downloadStore.possuiConexao) {
  //     _provaStore.setMensagemDownload(
  //       "Download não iniciado - Sem conexão com a internet",
  //     );
  //     _provaStore.prova!.status = ProvaStatusEnum.DownloadNaoIniciado;
  //   } else {
  //     _provaStore.prova!.status = ProvaStatusEnum.DowloadEmProgresso;
  //   }
  // }

  void atualizaProvaStorage(SharedPreferences prefs, ProvaCompletaModel provaCompleta, bool provaDownload) async {
    prefs.setString("prova_completa_${provaCompleta.id}", jsonEncode(provaCompleta.toJson()));

    prefs.setBool("prova_download_${provaCompleta.id}", provaDownload);
  }

  Future<void> downloadProva(
    ProvaModel prova,
    ProvaDetalheModel? provaDetalhe,
  ) async {
    // verificaConexaoComInternet();

    if (provaDetalhe == null) {
      return;
    }

    var prefs = await SharedPreferences.getInstance();
    _provaStore.baixando = true;
    ProvaCompletaModel provaCompleta = new ProvaCompletaModel(
      id: prova.id,
      descricao: prova.descricao,
      dataFim: prova.dataInicio,
      dataInicio: prova.dataFim,
      itensQuantidade: prova.itensQuantidade,
      status: prova.status,
    );
    //await prefs.remove("prova_download_${provaDetalhe.provaId}");
    var verificaProvaCompleta = prefs.getString("prova_completa_${provaDetalhe.provaId}");
    var verificaProvaDownload = prefs.getBool("prova_download_${provaDetalhe.provaId}");

    _downloadStore.totalItems =
        provaDetalhe.arquivosId!.length + provaDetalhe.alternativasId!.length + provaDetalhe.questoesId!.length;

    _downloadStore.posicaoAtual = 0;

    if (verificaProvaCompleta != null && verificaProvaDownload == true) {
      return;
    }

    _downloadStore.atualizaHoraInicial();

    // if (verificaProvaCompleta != null) {
    //   provaCompleta = ProvaCompletaModel.fromJson(jsonDecode(verificaProvaCompleta));
    // }

    if (provaCompleta.alternativas == null) {
      provaCompleta.alternativas = [];
    }

    if (provaCompleta.questoes == null) {
      provaCompleta.questoes = [];
    }

    if (provaCompleta.arquivos == null) {
      provaCompleta.arquivos = [];
    }

    for (int idArquivo in provaDetalhe.arquivosId!) {
      // verificaConexaoComInternet();

      var arquivo = await obterArquivo(idArquivo);

      if (provaCompleta.arquivos!.where((q) => q.id == arquivo!.id).isEmpty && arquivo != null) {
        var arquivoMetadata = await obterImagemPorUrlV2(arquivo.caminho);
        arquivo.base64 = arquivoMetadata.base64;
        provaCompleta.arquivos!.add(arquivo);
        _downloadStore.posicaoAtual += 1;
        print("Arquivo: ${arquivo.id}");
        atualizaProvaStorage(prefs, provaCompleta, false);
      }
    }

    for (int idQuestao in provaDetalhe.questoesId!) {
      // verificaConexaoComInternet();

      ProvaQuestaoModel? questao = await obterQuestao(idQuestao);

      if (provaCompleta.questoes!.where((q) => q.id == questao!.id).isEmpty && questao != null) {
        provaCompleta.questoes?.add(questao);
        _downloadStore.posicaoAtual += 1;
        print("Questão: ${questao.id}");
        atualizaProvaStorage(prefs, provaCompleta, false);
      }
    }

    for (int idAlternativa in provaDetalhe.alternativasId!) {
      // verificaConexaoComInternet();

      ProvaAlternativaModel? alternativa = await obterAlternativa(idAlternativa);

      if (provaCompleta.alternativas!.where((q) => q.id == alternativa!.id).isEmpty && alternativa != null) {
        provaCompleta.alternativas?.add(alternativa);
        _downloadStore.posicaoAtual += 1;
        print("Alternativa: ${alternativa.id}");
        atualizaProvaStorage(prefs, provaCompleta, false);
      }
    }

    for (ProvaQuestaoModel questao in provaCompleta.questoes!) {
      var alternativas = provaCompleta.alternativas!.where((alt) => alt.questaoId == questao.id).toList();

      questao.alternativas = alternativas;
      print("${questao.descricao}");
    }

    atualizaProvaStorage(prefs, provaCompleta, true);
    _downloadStore.limparDownloads();
    _provaStore.prova!.status = ProvaStatusEnum.IniciarProva;
    _provaStore.status = ProvaStatusEnum.IniciarProva;
    _provaStore.iconeProva = "assets/images/prova.svg";
    _provaStore.baixando = false;
  }
}
