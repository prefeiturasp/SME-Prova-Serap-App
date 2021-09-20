import 'dart:convert';

import 'package:appserap/dtos/autenticacao.dto.dart';
import 'package:appserap/dtos/rest/error.dto.dart';
import 'package:appserap/dtos/rest/respose.dto.dart';
import 'package:appserap/utils/api.util.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AutenticacaoService {
  final _api = GetIt.I.get<ApiUtil>();

  Future<ResponseDTO> autenticar(AutenticacaoDTO dto) async {
    ResponseDTO responseDTO = new ResponseDTO(success: false, content: "", errors: []);

    try {
      final response = await _api.dio.post(
        '/v1/autenticacao',
        data: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        responseDTO.success = true;
        responseDTO.content = response.data;
      }
    } on DioError catch (e, stackTrace) {
      switch (e.response?.statusCode) {
        case 411:
          responseDTO.errors.add(new ErrorDTO(code: 411, message: e.response?.data?['mensagens'][0]));
          break;
        case 412:
          responseDTO.errors.add(new ErrorDTO(code: 412, message: e.response?.data?['mensagens'][0]));
          break;
      }

      Sentry.captureException(e, stackTrace: stackTrace);
    }
    return responseDTO;
  }
}
