// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao_resposta.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$QuestaoRespostaService extends QuestaoRespostaService {
  _$QuestaoRespostaService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = QuestaoRespostaService;

  @override
  Future<Response<QuestaoRespostaResponseDTO>> getRespostaPorQuestaoId(
      {required int questaoId}) {
    final Uri $url = Uri.parse('/v1/questoes/${questaoId}/respostas');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<QuestaoRespostaResponseDTO, QuestaoRespostaResponseDTO>($request);
  }

  @override
  Future<Response<bool>> postResposta({
    required String chaveAPI,
    required List<QuestaoRespostaDTO> respostas,
  }) {
    final Uri $url = Uri.parse('/v1/questoes/respostas/sincronizar');
    final Map<String, String> $headers = {
      'chave-api': chaveAPI,
    };
    final $body = respostas;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<bool, bool>($request);
  }
}
