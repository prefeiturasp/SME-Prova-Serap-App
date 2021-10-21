import 'dart:convert';

import 'package:appserap/converters/error_converter.dart';
import 'package:appserap/converters/json_conveter.dart';
import 'package:appserap/interceptors/autenticacao.interceptor.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/services/rest/auth.service.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/user/http.fixture.dart';
import '../../fixtures/user/locator.fixture.dart';
import '../../fixtures/user/user.fixture.dart';
import 'login.test.mocks.dart';

@GenerateMocks([
  ApiService,
])
main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Auth -', () {
    setUp(() async {
      await registerLocators(defaultPreferences: {"token": UserFixture().autenticacaoResponse.token});
    });

    tearDown(() async {
      await GetIt.instance.reset();
    });

    test('Quando o usuario chamar o login, deve retornar um token valido', () async {
      final userEOL = UserFixture().userEOL;
      final userPassword = UserFixture().userPassword;

      final autenticacaoResponse = UserFixture().autenticacaoResponse;

      await registerLocators();

      MockClient httpClient = createHttpClient(
        UserJsonFixture().autenticacaoResponseJson,
      );

      AutenticacaoService service = buildClient(httpClient).getService<AutenticacaoService>();

      var dadosResponse = await service.login(
        login: userEOL,
        senha: userPassword,
      );

      expect(dadosResponse.isSuccessful, isTrue);
      expect(dadosResponse.statusCode, 200);
      expect(dadosResponse.body, autenticacaoResponse);
    });

    test('Quando o usuario chamar os meus-dados, deve retornar os dados vinculado ao token', () async {
      final autenticacaoResponse = UserFixture().autenticacaoResponse;
      final token = autenticacaoResponse.token;
      final autenticacaoDadosResponse = UserFixture().autenticacaoDadosResponse;

      final httpClient = createHttpClient(
        UserJsonFixture().autenticacaoDadosResponseJson,
        200,
        (req) {
          expect(req.headers['Authorization'], 'Bearer ' + token);
        },
      );

      AutenticacaoService service = buildClient(httpClient).getService<AutenticacaoService>();

      var dadosResponse = await service.meusDados();

      expect(dadosResponse.isSuccessful, isTrue);
      expect(dadosResponse.statusCode, 200);
      expect(dadosResponse.body, autenticacaoDadosResponse);
    });

    test(
      'Quando o usuario chamar o revalidar token, deve retornar deve retornar um token diferente',
      () async {
        final autenticacaoResponse = UserFixture().autenticacaoResponse;
        final token = autenticacaoResponse.token;

        final tokenNovo = UserFixture().autenticacaoRevalidarResponse.token;

        final autenticacaoDadosResponse = UserFixture().autenticacaoDadosResponse;

        await registerLocators(defaultPreferences: {"token": token});

        bool first = true;
        final httpClient = MockClient((req) async {
          if (req.url.toString() == "/v1/autenticacao/revalidar") {
            return http.Response(UserJsonFixture().autenticacaoRevalidateResponseJson, 200);
          }

          int statusCode = 401;

          if (!first) {
            statusCode = 200;
            expect(req.headers['Authorization'], 'Bearer ' + tokenNovo);
          } else {
            expect(req.headers['Authorization'], 'Bearer ' + token);
          }

          first = false;

          return http.Response(UserJsonFixture().autenticacaoDadosResponseJson, statusCode);
        });

        AutenticacaoService service = buildClient(httpClient).getService<AutenticacaoService>();

        when(GetIt.instance.get<ApiService>().auth).thenAnswer((_) => service);

        var dadosResponse = await service.meusDados();

        expect(dadosResponse.isSuccessful, isTrue);
        expect(dadosResponse.statusCode, 200);
        expect(dadosResponse.body, autenticacaoDadosResponse);
      },
      skip: true,
    );
  });
}
