import 'dart:async';

import 'package:appserap/dtos/autenticacao.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/main.route.gr.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:chopper/chopper.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceAuthenticator extends Authenticator with Loggable {
  bool refreshtoken = false;

  @override
  FutureOr<Request?> authenticate(Request request, Response<dynamic> response, [Request? originalRequest]) async {
    var prefs = sl<SharedPreferences>();

    if (response.statusCode == 401 && !refreshtoken) {
      refreshtoken = true;

      fine('401 - Não autorizado');

      String? token = prefs.getString('token');

      if (token == null) {
        fine('Token null - Redirecionando para o Login');
        await _deslogar();
        return null;
      }

      var newToken = await refreshToken(token);
      refreshtoken = false;
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
    } else if (response.statusCode != 200 && refreshtoken) {
      await _deslogar();
      return null;
    }
  }

  Future<String?> refreshToken(String oldToken) async {
    fine('Atualizando token');
    try {
      Response<AutenticacaoResponseDTO> response;

      if (sl.get<UsuarioStore>().isAdmin) {
        response = await sl<AutenticacaoAdminService>().revalidar(token: oldToken);
      } else {
        response = await sl<AutenticacaoService>().revalidar(token: oldToken);
      }

      if (response.isSuccessful) {
        String newToken = response.body!.token;
        DateTime expiration = response.body!.dataHoraExpiracao;
        fine('Novo token - Data Expiracao ($expiration) $newToken');

        var prefs = sl<SharedPreferences>();
        await prefs.setString('token', newToken);
        await prefs.setString('token_expiration', expiration.toIso8601String());
        return newToken;
      } else {
        await _deslogar();
      }
    } catch (e, stack) {
      severe('Erro ao atualizar token: $e');
      recordError(e, stack, reason: "Erro ao Atualizar token");
      await _deslogar();
    }

    return null;
  }

  _deslogar() async {
    info("Deslogando...");
    refreshtoken = false;
    final _principalStore = sl<PrincipalStore>();
    await _principalStore.sair();
    await sl.get<AppRouter>().replaceAll([LoginViewRoute()]);
  }
}

class CustomAuthInterceptor implements RequestInterceptor {
  CustomAuthInterceptor();

  @override
  FutureOr<Request> onRequest(Request request) async {
    var prefs = sl<SharedPreferences>();
    String? token = prefs.getString('token');

    if (token != null) {
      return applyHeaders(request, {'Authorization': 'Bearer $token'});
    }

    return request;
  }
}
