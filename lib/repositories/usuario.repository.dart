import 'dart:convert';

import 'package:appserap/models/token.model.dart';
import 'package:appserap/models/usuario.model.dart';
import 'package:appserap/services/dio.service.dart';
import 'package:appserap/stores/login.store.dart';
import 'package:appserap/view-models/autenticar.viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class UsuarioRepository {
  final _api = GetIt.I.get<ApiService>();
  final _loginStore = GetIt.I.get<LoginStore>();

  Future<TokenModel> autenticar(AutenticarViewModel viewModel) async {
    try {
      final response = await _api.dio.post(
        '/v1/autenticacao',
        data: jsonEncode(viewModel.toJson()),
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

  Future<UsuarioModel> obterDados() async {
    try {
      final response = await _api.dio.get('/v1/autenticacao/meus-dados');
      if (response.statusCode == 200) {
        var usuarioModel = UsuarioModel.fromJson(response.data);
        return usuarioModel;
      }
      return new UsuarioModel(nome: "", ano: "");
    } on DioError catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace: stackTrace);
      return new UsuarioModel(nome: "", ano: "");
    }
  }

  Future<String> revalidarToken(String? token) async {
    try {
      final response = await _api.dio
          .post('/v1/autenticacao/revalidar', data: {'token': token});

      if (response.statusCode == 200) {
        return response.data['token'];
      }

      return "";
    } catch (e) {
      print(e);
      return "";
    }
  }
}
