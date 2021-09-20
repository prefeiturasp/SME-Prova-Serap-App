// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ProvaService extends ProvaService {
  _$ProvaService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ProvaService;

  @override
  Future<Response<List<ProvaResponseDTO>>> getProvas() {
    final $url = '/provas';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<ProvaResponseDTO>, ProvaResponseDTO>($request);
  }

  @override
  Future<Response<ProvaDetalhesResponseDTO>> getResumoProva(
      {required int idProva}) {
    final $url = '/provas/$idProva/detalhes-resumido';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<ProvaDetalhesResponseDTO, ProvaDetalhesResponseDTO>($request);
  }
}
