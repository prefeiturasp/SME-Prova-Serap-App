import 'dart:async';

import 'package:appserap/dtos/autenticacao.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api.dart';
import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceAuthenticator extends Authenticator with Loggable {
  @override
  FutureOr<Request?> authenticate(Request request, Response<dynamic> response) async {
    if (response.statusCode == 401) {
      SharedPreferences prefs = GetIt.I.get();

      String? token = prefs.getString('token');
      // String? expiration = prefs.getString('token_expiration');

      if (token == null) {
        fine('Token null - Redirecionando para o Login');
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
      updatedHeaders.update('access-control-allow-origin', (value) => "*", ifAbsent: () => "*");
      updatedHeaders.update(
        'Access-Control-Allow-Methods',
        (value) => "GET, PUT, POST, DELETE, HEAD, OPTIONS, PATCH, PROPFIND, PROPPATCH, MKCOL, COPY, MOVE, LOCK",
        ifAbsent: () => "GET, PUT, POST, DELETE, HEAD, OPTIONS, PATCH, PROPFIND, PROPPATCH, MKCOL, COPY, MOVE, LOCK",
      );
      return request.copyWith(headers: updatedHeaders);
    }
  }

  Future<String?> refreshToken(String oldToken) async {
    ApiService service = GetIt.I.get();

    fine('Atualizando token');
    Response<AutenticacaoResponseDTO> response = await service.auth.revalidar(token: oldToken);

    if (response.isSuccessful) {
      String newToken = response.body!.token;
      DateTime expiration = response.body!.dataHoraExpiracao;
      fine('Novo token - Data Expiracao ($expiration) $newToken');

      SharedPreferences prefs = GetIt.I.get();
      await prefs.setString('token', newToken);
      await prefs.setString('token_expiration', expiration.toIso8601String());
      return newToken;
    }

    return null;
  }
}

class CustomAuthInterceptor implements RequestInterceptor {
  CustomAuthInterceptor();

  @override
  FutureOr<Request> onRequest(Request request) {
    SharedPreferences prefs = GetIt.I.get();
    String? token = prefs.getString('token');

    if (token != null) {
      return applyHeaders(request, {'Authorization': 'Bearer $token'});
    }

    return request;
  }
}
