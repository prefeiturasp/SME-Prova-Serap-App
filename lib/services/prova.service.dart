import 'dart:convert';

import 'package:appserap/dtos/arquivo_metadata.dto.dart';
import 'package:appserap/dtos/prova.dto.dart';
import 'package:appserap/dtos/prova_alternativa.dto.dart';
import 'package:appserap/dtos/prova_arquivo.dto.dart';
import 'package:appserap/dtos/prova_detalhe.dto.dart';
import 'package:appserap/dtos/prova_questao.dto.dart';
import 'package:appserap/utils/api.util.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class ProvaService {
  final _api = GetIt.I.get<ApiUtil>();

  Future<List<ProvaDTO>> obterProvas() async {
    try {
      final response = await _api.dio.get('/v1/provas');

      if (response.statusCode == 200) {
        var retorno = (response.data as List).map((x) => ProvaDTO.fromJson(x)).toList();
        return retorno;
      }
      return new List<ProvaDTO>.empty();
    } catch (e) {
      print(e);
      return new List<ProvaDTO>.empty();
    }
  }

  Future<ProvaDetalheDTO?> obterDetalhesProva(int id) async {
    try {
      final response = await _api.dio.get('/v1/provas/$id/detalhes-resumido');

      if (response.statusCode == 200) {
        var retorno = ProvaDetalheDTO.fromJson(response.data);
        return retorno;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ProvaArquivoDTO?> obterArquivo(int arquivoId) async {
    try {
      final response = await _api.dio.get('/v1/arquivos/$arquivoId/legado');
      if (response.statusCode == 200) {
        var retorno = ProvaArquivoDTO.fromJson(response.data);
        return retorno;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ArquivoMetadataDTO> obterImagemPorUrl(String? url) async {
    var arquivo = new ArquivoMetadataDTO();
    if (url != null) {
      try {
        final response = await _api.dio.get(url,
            //onReceiveProgress: exibirProgressoDownload,
            options: Options(
              responseType: ResponseType.bytes,
            ));
        arquivo.tamanho =
            response.headers['content-length']!.length > 0 ? int.parse(response.headers['content-length']![0]) : 0;
        arquivo.base64 = base64Encode(response.data);
        return arquivo;
      } catch (e) {
        print(e);
        return arquivo;
      }
    }
    return arquivo;
  }

  Future<ProvaQuestaoDTO?> obterQuestao(int questaoId) async {
    try {
      final response = await _api.dio.get('/v1/questoes/$questaoId');
      if (response.statusCode == 200) {
        var retorno = ProvaQuestaoDTO.fromJson(response.data);
        return retorno;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ProvaAlternativaDTO?> obterAlternativa(int alternativaId) async {
    try {
      final response = await _api.dio.get('/v1/alternativas/$alternativaId');
      if (response.statusCode == 200) {
        var retorno = ProvaAlternativaDTO.fromJson(response.data);
        return retorno;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
