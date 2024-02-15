// ignore_for_file: avoid_print

import 'dart:io';

import 'package:appserap/utils/string.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:logging/src/level.dart';
import 'package:native_resource/native_resource.dart';

abstract class AppConfigReader {
  static Future<void> initialize() async {
    Map<String, String> defaultNative = {};

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        defaultNative["HOST_API"] = await NativeResource().read(
          androidResourceName: 'api_url',
          iosPlistKey: 'ApiUrl',
        );

        defaultNative["SERAP_URL"] = await NativeResource().read(
          androidResourceName: 'serap_url',
          iosPlistKey: 'SerapUrl',
        );
        // ignore: empty_catches
      } on Exception {}
    }

    await dotenv.load(fileName: ".env", mergeWith: defaultNative);
  }

  static String getApiHost() {
    return dotenv.get("HOST_API", fallback: "NONE");
  }

  static String getSerapUrl() {
    return dotenv.get("SERAP_URL", fallback: "NONE");
  }

  static String getChaveApi() {
    return dotenv.get("CHAVE_API", fallback: "NONE");
  }

  static bool debugSql() {
    return dotenv.get("DEBUG_SQL", fallback: "false") == "true";
  }

  static String debugRequest() {
    return dotenv.get("DEBUG_REQUEST", fallback: "NONE");
  }

  static Level logLevel() {
    return parseLog(dotenv.get("NIVEL_LOG", fallback: "INFO"));
  }

  static printEnv() {
    print("HOST_API: " + getApiHost());
    print("SERAP_URL: " + getSerapUrl());
    print("CHAVE_API: " + getChaveApi());
    print("DEBUG_SQL: " + debugSql().toString());
    print("DEBUG_REQUEST: " + debugRequest());
    print("NIVEL_LOG: " + logLevel().toString());
  }
}
