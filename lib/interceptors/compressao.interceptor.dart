import 'dart:async';
import 'dart:io';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:chopper/chopper.dart';

class CompressaoInterceptor with Loggable implements RequestInterceptor {
  CompressaoInterceptor();

  @override
  FutureOr<Request> onRequest(Request request) {
    request = applyHeaders(request, {
      'Accept-Encoding': 'gzip, deflate',
    });

    return request;
  }
}
