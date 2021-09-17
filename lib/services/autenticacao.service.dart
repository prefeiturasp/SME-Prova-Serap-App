import 'dart:convert';

import 'package:appserap/dtos/autenticacao.dto.dart';
import 'package:appserap/models/token.model.dart';
import 'package:appserap/utils/api.util.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AutenticacaoService {
  final _api = GetIt.I.get<ApiUtil>();

  Future<TokenModel> autenticar(AutenticacaoDTO dto) async {
    try {
      final response = await _api.dio.post(
        '/v1/autenticacao',
        data: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        var tokenModel = TokenModel.fromJson(response.data);
        return tokenModel;
      }

      return new TokenModel(token: "", dataHoraExpiracao: "");
    } on DioError catch (e, stackTrace) {
      switch (e.response?.statusCode) {
        case 411:
          _loginStore.setMensagemErroEOL(e.response?.data?['mensagens'][0]);
          break;
        case 412:
          _loginStore.setMensagemErroSenha(e.response?.data['mensagens'][0]);
          break;
      }

      Sentry.captureException(e, stackTrace: stackTrace);
      return new TokenModel(token: "", dataHoraExpiracao: "");
    }
  }
}
