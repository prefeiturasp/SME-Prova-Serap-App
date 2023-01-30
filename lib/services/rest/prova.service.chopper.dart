// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ProvaService extends ProvaService {
  _$ProvaService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ProvaService;

  @override
  Future<Response<List<ProvaResponseDTO>>> getProvas() {
    final Uri $url = Uri.parse('/v1/provas');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<List<ProvaResponseDTO>, ProvaResponseDTO>($request);
  }

  @override
  Future<Response<ProvaDetalhesResponseDTO>> getResumoProva(
      {required int idProva}) {
    final Uri $url = Uri.parse('/v1/provas/${idProva}/detalhes-resumido');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<ProvaDetalhesResponseDTO, ProvaDetalhesResponseDTO>($request);
  }

  @override
  Future<Response<ProvaDetalhesCadernoResponseDTO>> getResumoProvaCaderno(
      {required int idProva, required String caderno}) {
    final Uri $url =
        Uri.parse('/v1/provas/${idProva}/detalhes-resumido-caderno/${caderno}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<ProvaDetalhesCadernoResponseDTO,
        ProvaDetalhesCadernoResponseDTO>($request);
  }

  @override
  Future<Response<int>> getStatusProva({required int idProva}) {
    final Uri $url = Uri.parse('/v1/provas/${idProva}/status-aluno');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<int, int>($request);
  }

  @override
  Future<Response<bool>> setStatusProva(
      {required int idProva,
      required int status,
      required int tipoDispositivo,
      int? dataInicio,
      int? dataFim}) {
    final Uri $url = Uri.parse('/v1/provas/${idProva}/status-aluno');
    final $body = <String, dynamic>{
      'status': status,
      'tipoDispositivo': tipoDispositivo,
      'dataInicio': dataInicio,
      'dataFim': dataFim
    };
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<bool, bool>($request);
  }

  @override
  Future<Response<List<QuestaoRespostaResponseDTO>>> getRespostasPorProvaId(
      {required int idProva}) {
    final Uri $url = Uri.parse('/v1/provas/${idProva}/respostas');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<List<QuestaoRespostaResponseDTO>,
        QuestaoRespostaResponseDTO>($request);
  }

  @override
  Future<Response<List<ProvaAnteriorResponseDTO>>> getProvasAnteriores() {
    final Uri $url = Uri.parse('/v1/provas/finalizadas');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<List<ProvaAnteriorResponseDTO>,
        ProvaAnteriorResponseDTO>($request);
  }
}
