import 'dart:async';

import 'package:get_it/get_it.dart';

registerInjection<T extends Object>(T instance) {
  final di = GetIt.instance;

  if (!di.isRegistered<T>()) {
    di.registerSingleton<T>(instance);
  }
}

void registerInjectionAsync<T extends Object>(Future<T> Function() instance) {
  final di = GetIt.instance;

  if (!di.isRegistered<T>()) {
    di.registerSingletonAsync<T>(instance);
  }
}

Future<FutureOr> unregisterInjection<T extends Object>({
  FutureOr<dynamic> Function(T)? disposingFunction,
}) async {
  final di = GetIt.instance;
  return di.unregister<T>(disposingFunction: disposingFunction);
}
