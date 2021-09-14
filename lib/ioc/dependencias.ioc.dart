import 'package:appserap/controllers/autenticacao.controller.dart';
import 'package:appserap/controllers/login.controller.dart';
import 'package:appserap/controllers/prova.controller.dart';
import 'package:appserap/controllers/splash_screen.controller.dart';
import 'package:appserap/repositories/login.repository.dart';
import 'package:appserap/repositories/prova.repository.dart';
import 'package:appserap/repositories/splash_screen.repository.dart';
import 'package:appserap/repositories/usuario.repository.dart';
import 'package:appserap/services/dio.service.dart';
import 'package:appserap/stores/download.store.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/login.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/splash_screen.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:get_it/get_it.dart';

class DependenciasIoC {
  late GetIt getIt;

  DependenciasIoC() {
    getIt = GetIt.instance;
  }

  registrarStores() {
    getIt.registerSingleton<UsuarioStore>(UsuarioStore());
    getIt.registerSingleton<ProvaStore>(ProvaStore());
    getIt.registerSingleton<LoginStore>(LoginStore());
    getIt.registerSingleton<SplashScreenStore>(SplashScreenStore());
    getIt.registerSingleton<DownloadStore>(DownloadStore());
    getIt.registerSingleton<HomeStore>(HomeStore());
  }

  registrarServices() {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }

  registrarRepositories() {
    getIt.registerSingleton<UsuarioRepository>(UsuarioRepository());
    getIt.registerSingleton<ProvaRepository>(ProvaRepository());
    getIt.registerSingleton<LoginRepository>(LoginRepository());
    getIt.registerSingleton<SplashScreenRepository>(SplashScreenRepository());
  }

  registrarControllers() {
    getIt.registerSingleton<AutenticacaoController>(AutenticacaoController());
    getIt.registerSingleton<ProvaController>(ProvaController());
    getIt.registerSingleton<LoginController>(LoginController());
    getIt.registerSingleton<SplashScreenController>(SplashScreenController());
  }
}
