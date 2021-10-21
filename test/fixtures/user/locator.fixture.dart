import 'package:appserap/services/api.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../unit/login/login.test.mocks.dart';

registerLocators({Map<String, Object> defaultPreferences = const {}}) async {
  final di = GetIt.instance;

  SharedPreferences.setMockInitialValues(defaultPreferences);

  di.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());
  di.registerSingleton<ApiService>(MockApiService());
}
