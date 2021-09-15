import 'package:appserap/controllers/splash_screen.controller.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_screen.store.g.dart';

class SplashScreenStore = _SplashScreenStoreBase with _$SplashScreenStore;

abstract class _SplashScreenStoreBase with Store {
  @observable
  String? versaoApp = "";

  @action
  Future<void> obterVersaoDoApp() async {
    var splashController = GetIt.I.get<SplashScreenController>();
    splashController.obterVersaoDoApp();

    var prefs = await SharedPreferences.getInstance();
    versaoApp = prefs.getString('versaoApp');
  }
}
