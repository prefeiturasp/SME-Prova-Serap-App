// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$LogService extends LogService {
  _$LogService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = LogService;

  @override
  Future<Response<bool>> logarNecessidadeDeUsoDaUrl(
      {required String chaveAPI,
      required String prova,
      required String aluno,
      required String escola,
      required String html}) {
    final $url = '/v1/imagemLog';
    final $headers = {
      'chave-api': chaveAPI,
    };

    final $body = <String, dynamic>{
      'prova': prova,
      'aluno': aluno,
      'escola': escola,
      'html': html
    };
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<bool, bool>($request);
  }
}
