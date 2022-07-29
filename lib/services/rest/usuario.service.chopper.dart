// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$UsuarioService extends UsuarioService {
  _$UsuarioService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UsuarioService;

  @override
  Future<Response<bool>> atualizarPreferencias(
      {required int tamanhoFonte, required int familiaFonte}) {
    final $url = '/v1/usuarios/preferencias';
    final $body = <String, dynamic>{
      'tamanhoFonte': tamanhoFonte,
      'familiaFonte': familiaFonte
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<bool, bool>($request);
  }
}
