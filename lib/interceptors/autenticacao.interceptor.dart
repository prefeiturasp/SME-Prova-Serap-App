import 'dart:async';

import 'package:appserap/dtos/autenticacao.response.dto.dart';
import 'package:appserap/services/api.dart';
import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceAuthenticator extends Authenticator {
  var log = Logger('ServiceAuthenticator');

  @override
  FutureOr<Request?> authenticate(Request request, Response<dynamic> response) async {
    // TODO obter o token antigo da store;

    if (response.statusCode == 401) {
      SharedPreferences pref = GetIt.I.get();

      String? token = pref.getString('token');
      String? expiration = pref.getString('token_expiration');

      if (token == null) {
        // TODO redirecionar para tela de login
        log.info('Redirecionando para o Login');
      }

      var newToken = await refreshToken(token!);
      token = newToken;

      // if (expiration == null || DateTime.parse(expiration).isBefore(DateTime.now())) {
      //   // Token expirou, atualizar
      //   log.info('Redirecionando para o Login');
      //   var newToken = await refreshToken(token!);
      //   token = newToken;
      // }

      Map<String, String> updatedHeaders = Map.of(request.headers);

      updatedHeaders.update('Authorization', (value) => "Bearer $token", ifAbsent: () => "Bearer $token");

      return request.copyWith(headers: updatedHeaders);
    }
  }

  Future<String?> refreshToken(String oldToken) async {
    ApiService service = GetIt.I.get();

    Response<AutenticacaoResponseDTO> response = await service.auth.revalidar(token: oldToken);

    if (response.isSuccessful) {
      String newToken = response.body!.token;
      DateTime expiration = response.body!.dataHoraExpiracao;

      SharedPreferences pref = GetIt.I.get();
      pref.setString('token', newToken);
      pref.setString('token_expiration', expiration.toIso8601String());

      return newToken;
    }

    return null;
  }
}

class CustomAuthInterceptor implements RequestInterceptor {
  CustomAuthInterceptor();

  @override
  FutureOr<Request> onRequest(Request request) {
    SharedPreferences pref = GetIt.I.get();
    String? token = pref.getString('token');

    if (token != null) {
      return applyHeaders(request, {'Authorization': 'Bearer $token'});
    }

    return request;
  }
}
