import 'package:appserap/converters/error_converter.dart';
import 'package:appserap/converters/json_conveter.dart';
import 'package:appserap/interceptors/autenticacao.interceptor.dart';
import 'package:chopper/chopper.dart';
import 'package:http/testing.dart';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http.fixture.mocks.dart';

Response<T> createResponse<T>(
  int status,
  T? data, {
  Map<String, String> headers = const {},
}) {
  return Response(http.Response('get Response', status, headers: headers), data);
}

buildClient([http.Client? httpClient]) {
  return ChopperClient(
    baseUrl: Uri.tryParse(''),
    client: httpClient,
    converter: jsonConverter,
    errorConverter: JsonErrorConverter(),
    authenticator: ServiceAuthenticator(),
    interceptors: [
      CustomAuthInterceptor(),
    ],
    services: [
      // AutenticacaoService.create(),
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

@GenerateMocks([
  http.BaseResponse,
])
Response<T> buildResponse<T extends Object>(T instance, {int statusCode = 200}) {
  var mockBaseResponse = MockBaseResponse();

  when(mockBaseResponse.statusCode).thenReturn(statusCode);

  return Response(
    mockBaseResponse,
    instance,
  );
}
