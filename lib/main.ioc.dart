import 'dart:async';

import 'package:appserap/services/api_service.dart';
import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.ioc.config.dart';

// ignore: non_constant_identifier_names
GetIt sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => sl.init();

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @injectable
  ChopperClient get chopperClient => ApiService.create();

  InternetConnection get internetConnection => InternetConnection();
}
