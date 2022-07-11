import 'dart:async';
import 'dart:convert';

import 'package:appserap/dtos/error.response.dto.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:chopper/chopper.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class JsonErrorConverter with Loggable implements ErrorConverter {
  @override
  FutureOr<Response<ErrorResponseDTO>> convertError<BodyType, InnerType>(Response response) {
    try {
      var body = ErrorResponseDTO.fromJson(jsonDecode(response.body));

      return response.copyWith<ErrorResponseDTO>(body: body);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      rethrow;
    }
  }
}
