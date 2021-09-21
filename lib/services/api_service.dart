import 'dart:io';

import 'package:appserap/converters/error_converter.dart';
import 'package:appserap/converters/json_conveter.dart';
import 'package:appserap/interceptors/autenticacao.interceptor.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/services/rest/versao.service.dart';
import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart' as http;

class ConnectionOptions {
  final String baseUrl;

  ConnectionOptions({
    required this.baseUrl,
  });
}

class ApiService {
  final ChopperClient chopper;

  ApiService._internal(this.chopper);

  factory ApiService.build(ConnectionOptions options) {
    final client = ApiService._internal(ChopperClient(
      client: options.baseUrl.contains("10.0.2.2")
          ? http.IOClient(
              HttpClient()
                ..connectionTimeout = const Duration(seconds: 5)
                ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true),
            )
          : http.IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 5),
            ),
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
        QuestaoRespostaService.create(),
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
  QuestaoRespostaService get questaoResposta => chopper.getService<QuestaoRespostaService>();
}
