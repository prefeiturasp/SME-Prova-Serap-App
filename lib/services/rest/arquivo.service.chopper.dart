// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arquivo.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ArquivoService extends ArquivoService {
  _$ArquivoService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ArquivoService;

  @override
  Future<Response<ArquivoResponseDTO>> getArquivo({required int idArquivo}) {
    final $url = '/v1/arquivos/${idArquivo}/legado';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<ArquivoResponseDTO, ArquivoResponseDTO>($request);
  }

  @override
  Future<Response<ArquivoResponseDTO>> getAudio({required int idArquivo}) {
    final $url = '/v1/arquivos/audio/${idArquivo}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<ArquivoResponseDTO, ArquivoResponseDTO>($request);
  }

  @override
  Future<Response<ArquivoVideoResponseDTO>> getVideo({required int idArquivo}) {
    final $url = '/v1/arquivos/video/${idArquivo}';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<ArquivoVideoResponseDTO, ArquivoVideoResponseDTO>($request);
  }
}
