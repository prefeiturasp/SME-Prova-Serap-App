// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'versao.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$VersaoService extends VersaoService {
  _$VersaoService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = VersaoService;

  @override
  Future<Response<String>> getVersao() {
    final $url = '/versoes';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> getVersaoFront() {
    final $url = '/versoes/front';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<String, String>($request);
  }
}
