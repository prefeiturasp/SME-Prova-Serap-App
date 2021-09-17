import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:get_it/get_it.dart';

class DependenciasIoC {
  late GetIt getIt;

  DependenciasIoC() {
    getIt = GetIt.instance;
  }

  registrarBaseStores() {}

  registrarStores() {
    getIt.registerSingleton<UsuarioStore>(UsuarioStore());
    getIt.registerSingleton<PrincipalStore>(PrincipalStore());
  }

  registrarUtils() {}

  registrarServices() {}

  registrarRepositories() {}

  registrarControllers() {}
}
