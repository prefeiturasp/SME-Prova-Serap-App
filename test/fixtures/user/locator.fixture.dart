import 'package:get_it/get_it.dart';

registerInjection<T extends Object>(T instance) {
  final di = GetIt.instance;

  if (!di.isRegistered<T>()) {
    di.registerSingleton<T>(instance);
  }
}

unregisterInjection<T extends Object>() async {
  final di = GetIt.instance;
  await di.unregister<T>();
}
