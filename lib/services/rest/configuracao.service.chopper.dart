// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuracao.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ConfiguracaoService extends ConfiguracaoService {
  _$ConfiguracaoService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ConfiguracaoService;

  @override
  Future<Response<DataHoraServidorDTO>> getDataHoraServidor() {
    final $url = '/v1/configuracoes/datahora';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DataHoraServidorDTO, DataHoraServidorDTO>($request);
  }
}
