import 'dart:io';

import 'package:appserap/converters/error_converter.dart';
import 'package:appserap/converters/json_conveter.dart';
import 'package:appserap/interceptors/autenticacao.interceptor.dart';
import 'package:appserap/interceptors/compressao.interceptor.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart' as httpio;
import 'package:http/http.dart' as http;

class ConnectionOptions {
  final String baseUrl;
  final String debugRequest;

  ConnectionOptions({
    required this.baseUrl,
    required this.debugRequest,
  });
}



class ApiService {

  static ChopperClient create() {
    var options = ConnectionOptions(
      baseUrl: AppConfigReader.getApiHost(),
      debugRequest: AppConfigReader.debugRequest(),
    );

    return ChopperClient(
      client: options.baseUrl.contains("10.0.2.2")
          ? httpio.IOClient(
        HttpClient()
          ..connectionTimeout = const Duration(seconds: 5)
          ..badCertificateCallback = ((X509Certificate cert, String host, int port) => true),
      )
          : http.Client(),
      baseUrl: Uri.tryParse(options.baseUrl),
      converter: jsonConverter,
      errorConverter: JsonErrorConverter(),
      authenticator: ServiceAuthenticator(),
      interceptors: [
        CompressaoInterceptor(),
        CustomAuthInterceptor(),
        ...options.debugRequest == "BASIC" ? [CurlInterceptor()] : [],
        ...options.debugRequest == "FULL" ? [HttpLoggingInterceptor()] : [],
      ],
    );
  }
}
