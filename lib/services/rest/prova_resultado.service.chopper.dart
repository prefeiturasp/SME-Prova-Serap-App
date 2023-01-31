// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prova_resultado.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$ProvaResultadoService extends ProvaResultadoService {
  _$ProvaResultadoService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ProvaResultadoService;

  @override
  Future<Response<ProvaResultadoResumoResponseDto>> getResumoPorProvaId(
      {required int provaId}) {
    final Uri $url = Uri.parse('/v1/prova-resultados/${provaId}/resumo');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<ProvaResultadoResumoResponseDto,
        ProvaResultadoResumoResponseDto>($request);
  }

  @override
  Future<Response<QuestaoCompletaRespostaResponseDto>> getQuestaoCompleta(
      {required int provaId, required int questaoLegadoId}) {
    final Uri $url = Uri.parse(
        '/v1/prova-resultados/${provaId}/${questaoLegadoId}/questao-completa');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<QuestaoCompletaRespostaResponseDto,
        QuestaoCompletaRespostaResponseDto>($request);
  }
}
