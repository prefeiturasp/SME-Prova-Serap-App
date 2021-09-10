
import 'package:appserap/repositories/splash_screen.repository.dart';
import 'package:get_it/get_it.dart';

class SplashScreenController {
  final _splashRepository = GetIt.I.get<SplashScreenRepository>();

  Future<void> obterVersaoDoApp() async {
    await _splashRepository.obterVersaoDoApp();
  }
}
