import 'dart:async';
import 'dart:io';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:brotli/brotli.dart';
import 'package:chopper/chopper.dart';

class CompressaoResponseInterceptor with Loggable implements ResponseInterceptor, RequestInterceptor {
  CompressaoResponseInterceptor();

  @override
  FutureOr<Response> onResponse(Response response) {
    info('Content-Type: ${response.headers['content-type']}');

    if (response.headers['Content-Encoding'] == 'br') {
      response = response.copyWith(body: brotli.decodeToString(response.bodyBytes));
    }

    return response;
  }

  @override
  FutureOr<Request> onRequest(Request request) {
    request = applyHeaders(request, {
      'Accept-Encoding': 'gzip, br, deflate',
    });

    return request;
  }
}
