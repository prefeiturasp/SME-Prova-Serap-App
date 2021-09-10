import 'package:appserap/services/dio.service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenRepository {
  final _api = GetIt.I.get<ApiService>();

  Future<void> obterVersaoDoApp() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      final response = await _api.dio.get('/v1/versoes/front');
      if (response.statusCode == 200) {
        prefs.setString("versaoApp", response.data);
      } else {
        prefs.setString("versaoApp", "Versão: 0");
      }
    } catch (e) {
      print(e);
    }
  }
}
