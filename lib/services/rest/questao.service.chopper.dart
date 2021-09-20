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
    final $url = '/questoes/$idQuestao';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<QuestaoResponseDTO, QuestaoResponseDTO>($request);
  }
}
