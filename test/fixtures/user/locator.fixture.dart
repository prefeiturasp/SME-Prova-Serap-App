import 'package:get_it/get_it.dart';

registerInjection<T extends Object>(T instance) {
  final di = GetIt.instance;

  if (!di.isRegistered<T>()) {
    di.registerSingleton<T>(instance);
  }
}
