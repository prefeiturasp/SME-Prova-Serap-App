import 'package:appserap/utils/string.util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:logging/src/level.dart';
import 'package:native_resource/native_resource.dart';

abstract class AppConfigReader {
  static Map<String, dynamic> _config = {};

  static Future<void> initialize() async {
    _config["apiHost"] = await NativeResource().read(
      androidResourceName: 'api_url',
      iosPlistKey: 'ApiUrl',
    );

    _config["serapUrl"] = await NativeResource().read(
      androidResourceName: 'serap_url',
      iosPlistKey: 'SerapUrl',
    );

    await dotenv.load(fileName: ".env");
  }

  static String getApiHost() {
    return _config["apiHost"];
  }

  static String getChaveApi() {
    return dotenv.get("CHAVE_API", fallback: "NONE");
  }

  static String getSerapUrl() {
    return _config["serapUrl"];
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
}
