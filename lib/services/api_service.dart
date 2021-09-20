import 'dart:async';

import 'package:appserap/converters/error_converter.dart';
import 'package:appserap/converters/json_conveter.dart';
import 'package:appserap/interceptors/autenticacao.interceptor.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/services/rest/versao.service.dart';
import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionOptions {
  final String baseUrl;

  ConnectionOptions({
    required this.baseUrl,
  });
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

class ApiService {
  final ChopperClient chopper;

  ApiService._internal(this.chopper);

  factory ApiService.build(ConnectionOptions options) {
    final client = ApiService._internal(ChopperClient(
      baseUrl: options.baseUrl,
      converter: jsonConverter,
      errorConverter: JsonErrorConverter(),
      authenticator: ServiceAuthenticator(),
      services: [
        AutenticacaoService.create(),
        ProvaService.create(),
        QuestaoService.create(),
        AlternativaService.create(),
        ArquivoService.create(),
        VersaoService.create(),
      ],
      interceptors: [
        CustomAuthInterceptor(),
        // CurlInterceptor(),
        // HttpLoggingInterceptor(),
      ],
    ));
    return client;
  }

  // Helpers for services
  AutenticacaoService get auth => chopper.getService<AutenticacaoService>();
  ProvaService get prova => chopper.getService<ProvaService>();
  QuestaoService get questao => chopper.getService<QuestaoService>();
  AlternativaService get alternativa => chopper.getService<AlternativaService>();
  ArquivoService get arquivo => chopper.getService<ArquivoService>();
  VersaoService get versao => chopper.getService<VersaoService>();
}
