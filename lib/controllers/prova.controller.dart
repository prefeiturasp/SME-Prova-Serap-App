import 'dart:convert';
import 'dart:developer';
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
  final _downloadStore = GetIt.I.get<DownloadStore>();
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
    await _downloadStore.verificaConexaoComInternet();
    _provaStore.setIconeProvaPorEstadoDeConexao(_downloadStore.possuiConexao);
    if (!_downloadStore.possuiConexao && _downloadStore.progressoDownload >= 0) {
      _provaStore.setMensagemDownload(
        "Pausado em ${(_downloadStore.progressoDownload * 100).toStringAsFixed(2)}% - Sem conexão com a internet",
      );
      _provaStore.prova!.status = ProvaStatusEnum.DownloadPausado;
    } else if (!_downloadStore.possuiConexao) {
      _provaStore.setMensagemDownload(
        "Download não iniciado - Sem conexão com a internet",
      );
      _provaStore.prova!.status = ProvaStatusEnum.DownloadNaoIniciado;
    } else {
      _provaStore.prova!.status = ProvaStatusEnum.DowloadEmProgresso;
    }
  }

  Future<void> downloadProva(
    ProvaModel prova,
    ProvaDetalheModel? detalhes,
  ) async {
    verificaConexaoComInternet();

    if (detalhes == null) {
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

    prefs.remove("prova_${detalhes.provaId}");
    var verificaProva = prefs.getString("prova_${detalhes.provaId}");

    _downloadStore.totalItems = detalhes.arquivosId!.length +
        detalhes.alternativasId!.length +
        detalhes.questoesId!.length;

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

    // detalhes.arquivosId!.forEach((arquivoIndex) async {
    //   await obterArquivo(arquivoIndex).then((arquivo) => {
    //         if (arquivo != null)
    //           {
    //             provaCompleta.arquivos?.add(arquivo),
    //             _dowloadStore.posicaoAtual += 1,
    //             print("Arquivo: ${arquivo.id}")
    //           }
    //       });
    // });

    for (int iArquivo = 0; iArquivo < totalArquivos; iArquivo++) {
      verificaConexaoComInternet();
      var arquivoIndex = detalhes.arquivosId![iArquivo];
      var arquivo = await obterArquivo(arquivoIndex);
      if (arquivo != null && !provaCompleta.arquivos!.contains(arquivo)) {
        arquivo.base64 = await obterImagemPorUrl(arquivo.caminho);
        provaCompleta.arquivos!.add(arquivo);
        _downloadStore.posicaoAtual += 1;
        print("Arquivo: ${arquivo.id}");
      }
    }

    // for (var iArquivo = 0; iArquivo < totalArquivos; iArquivo++) {
    //   var arquivoIndex = detalhes.arquivosId![iArquivo];

    //   await obterArquivo(arquivoIndex).then(
    //     (arquivo) async => {
    //       if (arquivo != null)
    //         {
    //           arquivo.base64 = await obterImagemPorUrl(arquivo.caminho),
    //           provaCompleta.arquivos?.add(arquivo),
    //           _dowloadStore.posicaoAtual += 1,
    //           print("Arquivo: ${arquivo.id}")
    //         }
    //     },
    //   );
    // }

    List<ProvaQuestaoModel> listaQuestoesAux = [];

    var totalQuestoes = detalhes.questoesId!.length;
    for (var iQuestao = 0; iQuestao < totalQuestoes; iQuestao++) {
      verificaConexaoComInternet();
      var questaoIndex = detalhes.questoesId![iQuestao];

      ProvaQuestaoModel? questao = await obterQuestao(questaoIndex);

      //print("QUESTAO: $questao");
      print("QUESTAO NA LISTA?: ${provaCompleta.questoes!.contains(questao)}");

      if (provaCompleta.questoes!.where((q) => q.id == questao!.id).isEmpty) {
        provaCompleta.questoes?.add(questao!);
        _downloadStore.posicaoAtual += 1;
        print("Questão: ${questao!.id}");
      }

      /* await obterQuestao(questaoIndex).then(
        (questao) => {
          if (questao != null && !listaQuestoesAux.contains(questao))
            {
              provaCompleta.questoes?.add(questao),
              listaQuestoesAux.add(questao),
              print(listaQuestoesAux),
              debugger()
              _downloadStore.posicaoAtual += 1,
              print("Questão: ${questao.id}")
            }
        },
      );*/

/*LUIZ


      var totalAlternativas = detalhes.alternativasId!.length;
      for (var iAlternativa = 0;
          iAlternativa < totalAlternativas;
          iAlternativa++) {
        verificaConexaoComInternet();
        var alternativaIndex = detalhes.alternativasId![iAlternativa];

        await obterAlternativa(alternativaIndex).then(
          (alternativa) => {
            if (alternativa != null &&
                !provaCompleta.alternativas!.contains(alternativa))
              {
                provaCompleta.alternativas?.add(alternativa),
                _downloadStore.posicaoAtual += 1,
                //print("Alternativa: ${alternativa.id}")
              }
          },
        );
      }

      prefs.setString("prova_${prova.id}", jsonEncode(provaCompleta.toJson()));


      //debugger();
*/
    }

    _downloadStore.limparDownloads();
    _provaStore.prova!.status = ProvaStatusEnum.IniciarProva;
    _provaStore.iconeProva = "assets/images/prova.svg";
    _provaStore.baixando = false;
  }
}
