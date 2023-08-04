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
  Future<Response<bool>> existeConexaoR() {
    final Uri $url = Uri.parse('/v1/provas-tai/existe-conexao-R');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<bool, bool>($request);
  }

  @override
  Future<Response<bool>> iniciarProva({
    required int provaId,
    required int status,
    required int tipoDispositivo,
    int? dataInicio,
    int? dataFim,
  }) {
    final Uri $url = Uri.parse('/v1/provas-tai/${provaId}/iniciar-prova');
    final $body = <String, dynamic>{
      'status': status,
      'tipoDispositivo': tipoDispositivo,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<bool, bool>($request);
  }

  @override
  Future<Response<bool>> finalizarProva({
    required int provaId,
    required int status,
    required int tipoDispositivo,
    int? dataInicio,
    int? dataFim,
  }) {
    final Uri $url = Uri.parse('/v1/provas-tai/${provaId}/finalizar-prova');
    final $body = <String, dynamic>{
      'status': status,
      'tipoDispositivo': tipoDispositivo,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<bool, bool>($request);
  }

  @override
  Future<Response<QuestaoCompletaTaiResponseDTO>> obterQuestao(
      {required int provaId}) {
    final Uri $url = Uri.parse('/v1/provas-tai/${provaId}/obter-questao');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<QuestaoCompletaTaiResponseDTO,
        QuestaoCompletaTaiResponseDTO>($request);
  }

  @override
  Future<Response<bool>> proximaQuestao({
    required int provaId,
    required QuestaoRespostaDTO resposta,
  }) {
    final Uri $url = Uri.parse('/v1/provas-tai/${provaId}/proximo');
    final $body = resposta;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<bool, bool>($request);
  }

  @override
  Future<Response<List<ProvaResumoTaiResponseDto>>> obterResumo(
      {required int provaId}) {
    final Uri $url = Uri.parse('/v1/provas-tai/${provaId}/resumo');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<ProvaResumoTaiResponseDto>,
        ProvaResumoTaiResponseDto>($request);
  }
}
