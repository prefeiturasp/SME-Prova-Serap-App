import 'package:appserap/converters/error_converter.dart';
import 'package:appserap/converters/json_conveter.dart';
import 'package:appserap/interceptors/autenticacao.interceptor.dart';
import 'package:appserap/managers/tempo.manager.dart';
import 'package:appserap/services/rest/auth.service.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import 'package:http/http.dart' as http;

Response<T> createResponse<T>(
  int status,
  T? data, {
  Map<String, String> headers = const {},
}) {
  return Response(http.Response('get Response', status, headers: headers), data);
}

buildClient([http.Client? httpClient]) {
  return ChopperClient(
    baseUrl: '',
    client: httpClient,
    converter: jsonConverter,
    errorConverter: JsonErrorConverter(),
    authenticator: ServiceAuthenticator(),
    interceptors: [
      CustomAuthInterceptor(),
    ],
    services: [
      AutenticacaoService.create(),
    ],
  );
}

createHttpClient(String response, [int statusCode = 200, Function(http.Request)? intercept]) {
  final httpClient = MockClient((http.Request req) async {
    if (intercept != null) {
      intercept(req);
    }

    return http.Response(
      response,
      statusCode,
    );
  });

  return httpClient;
}
