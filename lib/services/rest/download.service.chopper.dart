// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$DownloadService extends DownloadService {
  _$DownloadService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = DownloadService;

  @override
  Future<Response<String>> informarDownloadConcluido(
      {required int provaId,
      required int tipoDispositivo,
      required String dispositivoId,
      required String modeloDispositivo,
      required String versao,
      required String dataHora}) {
    final $url = '/v1/downloads';
    final $body = <String, dynamic>{
      'provaId': provaId,
      'tipoDispositivo': tipoDispositivo,
      'dispositivoId': dispositivoId,
      'modeloDispositivo': modeloDispositivo,
      'versao': versao,
      'dataHora': dataHora
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<String, String>($request);
  }

  @override
  Future<Response<void>> removerDownloads(
      {required String chaveAPI, required List<String> ids}) {
    final $url = '/v1/downloads';
    final $headers = {
      'chave-api': chaveAPI,
    };

    final $body = ids;
    final $request =
        Request('DELETE', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<void, void>($request);
  }
}
