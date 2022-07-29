// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questao.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$QuestaoService extends QuestaoService {
  _$QuestaoService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = QuestaoService;

  @override
  Future<Response<QuestaoResponseDTO>> getQuestao({required int idQuestao}) {
    final $url = '/v1/questoes/${idQuestao}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<QuestaoResponseDTO, QuestaoResponseDTO>($request);
  }

  @override
  Future<Response<List<QuestaoCompletaResponseDTO>>> getQuestaoCompleta(
      {required List<int> ids}) {
    final $url = '/v1/questoes/completas';
    final $params = <String, dynamic>{'ids': ids};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<List<QuestaoCompletaResponseDTO>,
        QuestaoCompletaResponseDTO>($request);
  }
}
