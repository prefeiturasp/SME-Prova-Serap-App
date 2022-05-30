import "dart:convert";
import 'package:appserap/utils/string.util.dart';
import "package:flutter/services.dart";

import 'package:logging/src/level.dart';

abstract class AppConfigReader {
  static Map<String, dynamic> _config = {};

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString("config/app_config.json");
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getEnvironment() {
    return _config["environment"] as String;
  }

  static String getSentryDsn() {
    return _config["sentryDsn"] as String;
  }

  static String getApiHost() {
    return _config["apiHost"] as String;
  }

  static String getChaveApi() {
    return _config["chaveApi"] as String;
  }

  static bool debugSql() {
    return _config["debugSQL"] ?? false;
  }

  static Level logLevel() {
    return parseLog(_config["logLevel"]);
  }
}
