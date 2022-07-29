// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$AutenticacaoService extends AutenticacaoService {
  _$AutenticacaoService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AutenticacaoService;

  @override
  Future<Response<AutenticacaoResponseDTO>> login(
      {required String login, required String senha}) {
    final $url = '/v1/autenticacao';
    final $body = <String, dynamic>{'login': login, 'senha': senha};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<AutenticacaoResponseDTO, AutenticacaoResponseDTO>($request);
  }

  @override
  Future<Response<AutenticacaoResponseDTO>> revalidar({required String token}) {
    final $url = '/v1/autenticacao/revalidar';
    final $body = <String, dynamic>{'token': token};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<AutenticacaoResponseDTO, AutenticacaoResponseDTO>($request);
  }

  @override
  Future<Response<AutenticacaoDadosResponseDTO>> meusDados() {
    final $url = '/v1/autenticacao/meus-dados';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<AutenticacaoDadosResponseDTO,
        AutenticacaoDadosResponseDTO>($request);
  }
}
