import 'package:appserap/controllers/autenticacao.controller.dart';
import 'package:appserap/controllers/prova.controller.dart';
import 'package:appserap/services/principal.service.dart';
import 'package:appserap/services/prova.repository.dart';
import 'package:appserap/repositories/usuario.repository.dart';
import 'package:appserap/utils/api.util.dart';
import 'package:appserap/stores/download.store.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/login.store.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/main.store.dart';
import 'package:appserap/stores/provas.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:get_it/get_it.dart';

class DependenciasIoC {
  late GetIt getIt;

  DependenciasIoC() {
    getIt = GetIt.instance;
  }

  registrarBaseStores() {
    getIt.registerSingleton<UsuarioStore>(UsuarioStore());
  }

  registrarStores() {
    getIt.registerSingleton<MainStore>(MainStore());
    getIt.registerSingleton<ProvaStore>(ProvaStore());
    getIt.registerSingleton<ProvasStore>(ProvasStore());
    getIt.registerSingleton<LoginStore>(LoginStore());
    getIt.registerSingleton<DownloadStore>(DownloadStore());
    getIt.registerSingleton<HomeStore>(HomeStore());
  }

  registrarUtils() {
    getIt.registerLazySingleton<ApiUtil>(() => ApiUtil());
  }

  registrarServices() {
    getIt.registerSingleton<PrincipalService>(PrincipalService());
  }

  registrarRepositories() {
    getIt.registerSingleton<UsuarioRepository>(UsuarioRepository());
    getIt.registerSingleton<ProvaRepository>(ProvaRepository());
  }

  registrarControllers() {
    getIt.registerSingleton<AutenticacaoController>(AutenticacaoController());
    getIt.registerSingleton<ProvaController>(ProvaController());
  }
}
