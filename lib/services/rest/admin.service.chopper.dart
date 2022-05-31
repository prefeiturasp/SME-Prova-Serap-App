// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$AdminService extends AdminService {
  _$AdminService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AdminService;

  @override
  Future<Response<ListagemAdminProvaResponseDTO>> getProvas(
      {int? quantidadeRegistros,
      int? numeroPagina,
      int? provaLegadoId,
      int? modalidade,
      String? descricao,
      String? ano}) {
    final $url = '/v1/admin/provas';
    final $params = <String, dynamic>{
      'quantidadeRegistros': quantidadeRegistros,
      'numeroPagina': numeroPagina,
      'provaLegadoId': provaLegadoId,
      'modalidade': modalidade,
      'descricao': descricao,
      'ano': ano
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ListagemAdminProvaResponseDTO,
        ListagemAdminProvaResponseDTO>($request);
  }

  @override
  Future<Response<AdminProvaCadernoResponseDTO>> getCadernos(
      {required int idProva}) {
    final $url = '/v1/admin/provas/${idProva}/cadernos';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<AdminProvaCadernoResponseDTO,
        AdminProvaCadernoResponseDTO>($request);
  }

  @override
  Future<Response<List<AdminProvaResumoResponseDTO>>> getResumo(
      {required int idProva}) {
    final $url = '/v1/admin/provas/${idProva}/resumos';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<AdminProvaResumoResponseDTO>,
        AdminProvaResumoResponseDTO>($request);
  }

  @override
  Future<Response<List<AdminProvaResumoResponseDTO>>> getResumoByCaderno(
      {required int idProva, required String caderno}) {
    final $url = '/v1/admin/provas/${idProva}/cadernos/${caderno}/resumos';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<AdminProvaResumoResponseDTO>,
        AdminProvaResumoResponseDTO>($request);
  }

  @override
  Future<Response<AdminQuestaoDetalhesResponseDTO>> getDetalhes(
      {required int idProva, required int idQuestao}) {
    final $url = '/v1/admin/provas/${idProva}/questoes/${idQuestao}/detalhes';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<AdminQuestaoDetalhesResponseDTO,
        AdminQuestaoDetalhesResponseDTO>($request);
  }
}
