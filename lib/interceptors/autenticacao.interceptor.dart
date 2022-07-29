import 'dart:async';

import 'package:appserap/dtos/autenticacao.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceAuthenticator extends Authenticator with Loggable {
  @override
  FutureOr<Request?> authenticate(Request request, Response<dynamic> response, [Request? originalRequest]) async {
    SharedPreferences prefs = GetIt.I.get();

    if (response.statusCode == 401) {
      if (response.bodyString.contains("Token inválido")) {
        await _deslogar();
        return null;
      }

      fine('401 - Não autorizado');

      String? token = prefs.getString('token');

      if (token == null) {
        fine('Token null - Redirecionando para o Login');
        await _deslogar();
        return null;
      }

      var newToken = await refreshToken(token);
      token = newToken;

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
    try {
      Response<AutenticacaoResponseDTO> response;

      if (ServiceLocator.get<UsuarioStore>().isAdmin) {
        response = await service.adminAuth.revalidar(token: oldToken);
      } else {
        response = await service.auth.revalidar(token: oldToken);
      }

      if (response.isSuccessful) {
        String newToken = response.body!.token;
        DateTime expiration = response.body!.dataHoraExpiracao;
        fine('Novo token - Data Expiracao ($expiration) $newToken');

        SharedPreferences prefs = GetIt.I.get();
        await prefs.setString('token', newToken);
        await prefs.setString('token_expiration', expiration.toIso8601String());
        return newToken;
      } else {
        await _deslogar();
      }
    } catch (e) {
      severe('Erro ao atualizar token: $e');
      await _deslogar();
    }

    return null;
  }

  _deslogar() async {
    info("Deslogando...");
    final _principalStore = GetIt.I.get<PrincipalStore>();
    await _principalStore.sair();
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
