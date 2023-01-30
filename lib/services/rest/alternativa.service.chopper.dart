// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternativa.service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$AlternativaService extends AlternativaService {
  _$AlternativaService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AlternativaService;

  @override
  Future<Response<AlternativaResponseDTO>> getAlternativa(
      {required int idAlternativa}) {
    final Uri $url = Uri.parse('/v1/alternativas/${idAlternativa}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client
        .send<AlternativaResponseDTO, AlternativaResponseDTO>($request);
  }
}
