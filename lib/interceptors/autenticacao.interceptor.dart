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
      SharedPreferences pref = GetIt.I.get();

      String? token = pref.getString('token');
      String? expiration = pref.getString('token_expiration');

      if (token == null) {
        fine('Token null - Redirecionando para o Login');
      }

      if (expiration == null || DateTime.parse(expiration).isBefore(DateTime.now())) {
        // Token expirou, atualizar
        fine('Token expirou - Atualizando token');
        var newToken = await refreshToken(token!);
        token = newToken;
      }

      Map<String, String> updatedHeaders = Map.of(request.headers);

      updatedHeaders.update('Authorization', (value) => "Bearer $token", ifAbsent: () => "Bearer $token");

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
