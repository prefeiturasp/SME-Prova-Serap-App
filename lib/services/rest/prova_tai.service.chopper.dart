// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_tai.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ProvaTaiService extends ProvaTaiService {
  _$ProvaTaiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ProvaTaiService;

  @override
  Future<Response<bool>> iniciarProva(
      {required int provaId,
      required int status,
      required int tipoDispositivo,
      int? dataInicio,
      int? dataFim}) {
    final $url = '/v1/provas-tai/${provaId}/iniciar-prova';
    final $body = <String, dynamic>{
      'status': status,
      'tipoDispositivo': tipoDispositivo,
      'dataInicio': dataInicio,
      'dataFim': dataFim
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<bool, bool>($request);
  }

  @override
  Future<Response<QuestaoCompletaResponseDTO>> obterQuestao(
      {required int provaId}) {
    final $url = '/v1/provas-tai/${provaId}/obter-questao';
    final $request = Request('POST', $url, client.baseUrl);
    return client
        .send<QuestaoCompletaResponseDTO, QuestaoCompletaResponseDTO>($request);
  }

  @override
  Future<Response<bool>> existeConexaoR() {
    final $url = '/v1/provas-tai/existe-conexao-R';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<bool, bool>($request);
  }
}
