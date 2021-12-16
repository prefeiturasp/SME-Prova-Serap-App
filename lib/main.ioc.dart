import 'dart:async';

import 'package:appserap/database/app.database.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/services/api_service.dart';
import 'package:appserap/stores/apresentacao.store.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/login.store.dart';
import 'package:appserap/stores/orientacao_inicial.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/prova.view.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'stores/home_provas_anteriores.store.dart';

// ignore: non_constant_identifier_names
GetIt ServiceLocator = GetIt.instance;

class DependenciasIoC with Loggable {
  setup() async {
    config('Configurando Injeção de Dependencias');
    ServiceLocator.allowReassignment = true;
    registrarServicos();
    registrarStores();
    await ServiceLocator.allReady();
  }

  registrarServicos() {
    registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
    registerSingleton<AppDatabase>(constructDb());
    registerSingleton<ApiService>(ApiService.build(
      ConnectionOptions(
        baseUrl: AppConfigReader.getApiHost(),
      ),
    ));
  }

  registrarStores() {
    registerSingleton<UsuarioStore>(UsuarioStore());
    registerSingleton<PrincipalStore>(PrincipalStore());
    registerSingleton<LoginStore>(LoginStore());
    registerSingleton<TemaStore>(TemaStore());
    registerSingleton<HomeStore>(HomeStore());
    registerSingleton<ProvaViewStore>(ProvaViewStore());
    registerSingleton<ApresentacaoStore>(ApresentacaoStore());
    registerSingleton<OrientacaoInicialStore>(OrientacaoInicialStore());
    registerSingleton<HomeProvasAnterioresStore>(HomeProvasAnterioresStore());
  }

  void registerSingletonAsync<T extends Object>(
    Future<T> Function() factoryFunc, {
    String? instanceName,
    Iterable<Type>? dependsOn,
    bool? signalsReady,
    FutureOr<dynamic> Function(T)? dispose,
  }) {
    if (!ServiceLocator.isRegistered<T>()) {
      fine('[SingletonAsync] Registrando ${T.toString()}');
      ServiceLocator.registerSingletonAsync<T>(
        factoryFunc,
        instanceName: instanceName,
        dependsOn: dependsOn,
        signalsReady: signalsReady,
        dispose: dispose,
      );
    }
  }

  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
    bool? signalsReady,
    FutureOr<dynamic> Function(T)? dispose,
  }) {
    if (!ServiceLocator.isRegistered<T>()) {
      fine('[Singleton] Registrando ${T.toString()}');
      ServiceLocator.registerSingleton<T>(
        instance,
        instanceName: instanceName,
        signalsReady: signalsReady,
        dispose: dispose,
      );
    }
  }
}
