// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contexto_prova.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ContextoProvaService extends ContextoProvaService {
  _$ContextoProvaService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ContextoProvaService;

  @override
  Future<Response<ContextoProvaResponseDTO>> getContextoProva(
      {required int id}) {
    final $url = '/v1/contextos-provas/${id}';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<ContextoProvaResponseDTO, ContextoProvaResponseDTO>($request);
  }

  @override
  Future<Response<List<ContextoProvaResponseDTO>>> getContextosPorProva(
      {required int idProva}) {
    final $url = '/v1/contextos-provas/provas/${idProva}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<ContextoProvaResponseDTO>,
        ContextoProvaResponseDTO>($request);
  }
}
