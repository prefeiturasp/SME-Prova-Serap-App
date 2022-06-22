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
    final $url = '/v1/provas';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<ProvaResponseDTO>, ProvaResponseDTO>($request);
  }

  @override
  Future<Response<ProvaDetalhesResponseDTO>> getResumoProva(
      {required int idProva}) {
    final $url = '/v1/provas/${idProva}/detalhes-resumido';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<ProvaDetalhesResponseDTO, ProvaDetalhesResponseDTO>($request);
  }

  @override
  Future<Response<int>> getStatusProva({required int idProva}) {
    final $url = '/v1/provas/${idProva}/status-aluno';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<int, int>($request);
  }

  @override
  Future<Response<bool>> setStatusProva(
      {required int idProva,
      required int status,
      required int tipoDispositivo,
      int? dataFim}) {
    final $url = '/v1/provas/${idProva}/status-aluno';
    final $body = <String, dynamic>{
      'status': status,
      'tipoDispositivo': tipoDispositivo,
      'dataFim': dataFim
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<bool, bool>($request);
  }

  @override
  Future<Response<List<QuestaoRespostaResponseDTO>>> getRespostasPorProvaId(
      {required int idProva}) {
    final $url = '/v1/provas/${idProva}/respostas';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<QuestaoRespostaResponseDTO>,
        QuestaoRespostaResponseDTO>($request);
  }

  @override
  Future<Response<List<ProvaAnteriorResponseDTO>>> getProvasAnteriores() {
    final $url = '/v1/provas/finalizadas';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<ProvaAnteriorResponseDTO>,
        ProvaAnteriorResponseDTO>($request);
  }
}
