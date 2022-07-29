// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orientacao_inicial.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$OrientacaoInicialService extends OrientacaoInicialService {
  _$OrientacaoInicialService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = OrientacaoInicialService;

  @override
  Future<Response<List<OrientacaoInicialResponseDTO>>>
      getOrientacoesIniciais() {
    final $url = '/v1/configuracoes/telas-boas-vindas';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<OrientacaoInicialResponseDTO>,
        OrientacaoInicialResponseDTO>($request);
  }
}
