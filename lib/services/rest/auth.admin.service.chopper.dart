// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.admin.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$AutenticacaoAdminService extends AutenticacaoAdminService {
  _$AutenticacaoAdminService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AutenticacaoAdminService;

  @override
  Future<Response<AutenticacaoResponseDTO>> loginByCodigoAutenticacao(
      {required String codigo}) {
    final $url = '/v1/admin/autenticacao/validar';
    final $body = <String, dynamic>{'codigo': codigo};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<AutenticacaoResponseDTO, AutenticacaoResponseDTO>($request);
  }

  @override
  Future<Response<AutenticacaoResponseDTO>> revalidar({required String token}) {
    final $url = '/v1/admin/autenticacao/revalidar';
    final $body = <String, dynamic>{'token': token};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client
        .send<AutenticacaoResponseDTO, AutenticacaoResponseDTO>($request);
  }
}
