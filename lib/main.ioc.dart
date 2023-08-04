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
import 'package:appserap/stores/questao_revisao.store.dart';
import 'package:appserap/stores/questao_tai_view.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/respostas.database.dart';
import 'main.route.dart';
import 'stores/admin_prova_caderno.store.dart';
import 'stores/admin_prova_contexto.store.dart';
import 'stores/admin_prova_questao.store.dart';
import 'stores/admin_prova_resumo.store.dart';
import 'stores/contexto_prova_view.store.dart';
import 'stores/home.admin.store.dart';
import 'stores/home_provas_anteriores.store.dart';
import 'stores/job.store.dart';
import 'stores/login_adm.store.dart';
import 'stores/prova_resultado_resumo_view.store.dart';
import 'stores/prova_tai.view.store.dart';
import 'stores/questao.store.dart';
import 'stores/questao_resultado_detalhes_view.store.dart';
import 'stores/resumo_tai_view.store.dart';

// ignore: non_constant_identifier_names
GetIt ServiceLocator = GetIt.instance;

class DependenciasIoC with Loggable {
  setup() async {
    config('Configurando Injeção de Dependencias');
    ServiceLocator.allowReassignment = true;
    registrarServicosAsync();
    await ServiceLocator.allReady();

    registrarServicos();
    registrarStores();
    await ServiceLocator.allReady();
  }

  registrarServicosAsync() {
    registerSingletonAsync<SharedPreferences>(() async => SharedPreferences.getInstance());
  }

  registrarServicos() {
    registerSingleton<AppDatabase>(AppDatabase());
    registerSingleton<RespostasDatabase>(RespostasDatabase());
    registerSingleton<ApiService>(ApiService.build(
      ConnectionOptions(
        baseUrl: AppConfigReader.getApiHost(),
        debugRequest: AppConfigReader.debugRequest(),
      ),
    ));
    registerSingleton<AppRouter>(AppRouter());
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
    registerSingleton<QuestaoStore>(QuestaoStore());
    registerSingleton<QuestaoRevisaoStore>(QuestaoRevisaoStore());
    registerSingleton<LoginAdmStore>(LoginAdmStore());
    registerSingleton<HomeAdminStore>(HomeAdminStore());
    registerSingleton<AdminProvaCadernoViewStore>(AdminProvaCadernoViewStore());
    registerSingleton<AdminProvaResumoViewStore>(AdminProvaResumoViewStore());
    registerSingleton<AdminProvaQuestaoViewStore>(AdminProvaQuestaoViewStore());
    registerSingleton<AdminProvaContextoViewStore>(AdminProvaContextoViewStore());
    registerSingleton<ContextoProvaViewStore>(ContextoProvaViewStore());
    registerSingleton<JobStore>(JobStore());
    registerSingleton<ProvaResultadoResumoViewStore>(ProvaResultadoResumoViewStore());
    registerSingleton<QuestaoResultadoDetalhesViewStore>(QuestaoResultadoDetalhesViewStore());
    registerSingleton<ProvaTaiViewStore>(ProvaTaiViewStore());
    registerSingleton<QuestaoTaiViewStore>(QuestaoTaiViewStore());
    registerSingleton<ResumoTaiViewStore>(ResumoTaiViewStore());
  }

  void registerSingletonAsync<T extends Object>(
    Future<T> Function() factoryFunc, {
    String? instanceName,
    Iterable<Type>? dependsOn,
    bool? signalsReady,
    FutureOr<dynamic> Function(T)? dispose,
  }) {
    if (!ServiceLocator.isRegistered<T>()) {
      finest('[SingletonAsync] Registrando ${T.toString()}');
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
      finest('[Singleton] Registrando ${T.toString()}');
      ServiceLocator.registerSingleton<T>(
        instance,
        instanceName: instanceName,
        signalsReady: signalsReady,
        dispose: dispose,
      );
    }
  }
}
