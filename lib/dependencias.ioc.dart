import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/login.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependenciasIoC {
  late GetIt getIt;

  DependenciasIoC() {
    getIt = GetIt.instance;
  }

  registrar() {
    GetIt.I.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());

    GetIt.I.registerSingleton<ApiService>(ApiService.build(
      ConnectionOptions(
        baseUrl: AppConfigReader.getApiHost(),
      ),
    ));

    GetIt.I.registerSingleton<UsuarioStore>(UsuarioStore());
    GetIt.I.registerSingleton<PrincipalStore>(PrincipalStore());
    GetIt.I.registerSingleton<LoginStore>(LoginStore());
    GetIt.I.registerSingleton<HomeStore>(HomeStore());
    GetIt.I.registerSingleton<ProvaViewStore>(ProvaViewStore());
  }
}
