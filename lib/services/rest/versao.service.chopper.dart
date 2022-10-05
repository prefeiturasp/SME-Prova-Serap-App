// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'versao.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$VersaoService extends VersaoService {
  _$VersaoService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = VersaoService;

  @override
  Future<Response<String>> getVersao() {
    final $url = '/v1/versoes';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> getVersaoFront() {
    final $url = '/v1/versoes/front';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<String, String>($request);
  }

  @override
  Future<Response<VersaoAtualizacaoResponseDTO>> getAtualizacao() {
    final $url = '/v1/versoes/atualizacao';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<VersaoAtualizacaoResponseDTO,
        VersaoAtualizacaoResponseDTO>($request);
  }

  @override
  Future<Response<bool>> informarVersao(
      {required String chaveAPI,
      required int versaoCodigo,
      required String versaoDescricao,
      String? dispositivoImei,
      required String atualizadoEm,
      String? dispositivoId}) {
    final $url = '/v1/versoes/dispositivo';
    final $headers = {
      'chave-api': chaveAPI,
    };

    final $body = <String, dynamic>{
      'versaoCodigo': versaoCodigo,
      'versaoDescricao': versaoDescricao,
      'dispositivoImei': dispositivoImei,
      'atualizadoEm': atualizadoEm,
      'dispositivoId': dispositivoId
    };
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<bool, bool>($request);
  }
}
