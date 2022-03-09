import 'package:appserap/stores/admin_prova_questao.store.dart';
import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/views/login/login.view.dart';
import 'package:appserap/ui/views/orientacao_inicial/orientacao_inicial.view.dart';
import 'package:appserap/ui/views/prova/contexto_prova.view.dart';
import 'package:appserap/ui/views/prova/prova.view.dart';
import 'package:appserap/ui/views/prova/questao.view.dart';
import 'package:appserap/ui/views/prova/resumo_respostas.view.dart';
import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart';
import 'package:appserap/utils/router.util.dart';
import 'package:go_router/go_router.dart';

import 'dtos/admin_prova_resumo.response.dto.dart';
import 'ui/views/admin/prova_questao.admin.view.dart';
import 'ui/views/admin/prova_resumo.admin.view.dart';
import 'ui/views/admin/prova_resumo_caderno.admin.view.dart';
import 'ui/views/error/error.view.dart';
import 'ui/views/admin/home.admin.view.dart';
import 'ui/views/login/login.adm.view.dart';
import 'ui/views/prova/questao_revisao.view.dart';

class AppRouter {
  GoRouter get router => _goRouter;

  AppRouter();

  late final GoRouter _goRouter = GoRouter(
    initialLocation: APP_PAGE.SPLASH.toPath,
    debugLogDiagnostics: false,
    routes: <GoRoute>[
      GoRoute(
        path: APP_PAGE.ERRO.toPath,
        name: APP_PAGE.ERRO.toName,
        builder: (context, state) => ErrorPage(error: state.extra.toString()),
      ),
      GoRoute(
        path: APP_PAGE.SPLASH.toPath,
        name: APP_PAGE.SPLASH.toName,
        builder: (context, state) => const SplashScreenView(),
      ),
      GoRoute(
        path: APP_PAGE.LOGIN.toPath,
        name: APP_PAGE.LOGIN.toName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: APP_PAGE.LOGIN_ADM.toPath,
        name: APP_PAGE.LOGIN_ADM.toName,
        builder: (context, state) {
          var login = state.params['login']!;
          var nome = state.params['nome']!;
          var perfil = state.params['perfil']!;
          var chaveApi = state.params['chaveApi']!;
          return LoginAdmView(
            login: login,
            nome: nome,
            perfil: perfil,
            chaveApi: chaveApi,
          );
        },
      ),
      GoRoute(
        path: APP_PAGE.BOAS_VINDAS.toPath,
        name: APP_PAGE.BOAS_VINDAS.toName,
        builder: (context, state) => const OrientacaoInicialView(),
      ),
      // Home
      GoRoute(
        path: APP_PAGE.HOME.toPath,
        name: APP_PAGE.HOME.toName,
        builder: (context, state) => HomeView(),
      ),

      // Provas
      GoRoute(
        path: APP_PAGE.PROVA.toPath,
        name: APP_PAGE.PROVA.toName,
        builder: (context, state) {
          var idProva = int.tryParse(state.params['idProva']!);
          return ProvaView(idProva: idProva!);
        },
      ),
      GoRoute(
        path: APP_PAGE.CONTEXTO_PROVA.toPath,
        name: APP_PAGE.CONTEXTO_PROVA.toName,
        builder: (context, state) {
          var idProva = int.tryParse(state.params['idProva']!);
          return ContextoProvaView(idProva: idProva!);
        },
      ),
      GoRoute(
        path: APP_PAGE.QUESTAO.toPath,
        name: APP_PAGE.QUESTAO.toName,
        builder: (context, state) {
          var idProva = int.tryParse(state.params['idProva']!);
          var ordem = int.tryParse(state.params['ordem']!);
          return QuestaoView(idProva: idProva!, ordem: ordem!);
        },
      ),
      GoRoute(
        path: APP_PAGE.RESUMO.toPath,
        name: APP_PAGE.RESUMO.toName,
        builder: (context, state) {
          var idProva = int.tryParse(state.params['idProva']!);
          return ResumoRespostasView(idProva: idProva!);
        },
      ),
      GoRoute(
        path: APP_PAGE.REVISAO_QUESTAO.toPath,
        name: APP_PAGE.REVISAO_QUESTAO.toName,
        builder: (context, state) {
          var idProva = int.tryParse(state.params['idProva']!);
          var ordem = int.tryParse(state.params['ordem']!);
          return QuestaoRevisaoView(idProva: idProva!, ordem: ordem!);
        },
      ),
      GoRoute(
        path: APP_PAGE.ADMIN_HOME.toPath,
        name: APP_PAGE.ADMIN_HOME.toName,
        builder: (context, state) {
          return HomeAdminView();
        },
      ),
      GoRoute(
        path: APP_PAGE.ADMIN_PROVA_CADERNO.toPath,
        name: APP_PAGE.ADMIN_PROVA_CADERNO.toName,
        builder: (context, state) {
          int? idProva = int.tryParse(state.params['idProva']!);
          return AdminProvaCadernoView(idProva: idProva!);
        },
      ),
      GoRoute(
        path: APP_PAGE.ADMIN_PROVA_RESUMO.toPath,
        name: APP_PAGE.ADMIN_PROVA_RESUMO.toName,
        builder: (context, state) {
          int? idProva = int.tryParse(state.params['idProva']!);
          return AdminProvaResumoView(idProva: idProva!, nomeCaderno: null);
        },
      ),
      GoRoute(
        path: APP_PAGE.ADMIN_PROVA_RESUMO_CADERNO.toPath,
        name: APP_PAGE.ADMIN_PROVA_RESUMO_CADERNO.toName,
        builder: (context, state) {
          int? idProva = int.tryParse(state.params['idProva']!);
          String? nomeCaderno = state.params['nomeCaderno']!;
          return AdminProvaResumoView(idProva: idProva!, nomeCaderno: nomeCaderno);
        },
      ),
      GoRoute(
        path: APP_PAGE.ADMIN_PROVA_QUESTAO.toPath,
        name: APP_PAGE.ADMIN_PROVA_QUESTAO.toName,
        builder: (context, state) {
          int? idProva = int.tryParse(state.params['idProva']!);
          int? ordem = int.tryParse(state.params['ordem']!);
          List<AdminProvaResumoResponseDTO> resumo = state.extra as List<AdminProvaResumoResponseDTO>;
          return AdminProvaQuestaoView(idProva: idProva!, ordem: ordem!, resumo: resumo);
        },
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error.toString()),
    redirect: (state) {
      // final loginLocation = state.namedLocation(APP_PAGE.LOGIN.toName);
      // final homeLocation = state.namedLocation(APP_PAGE.home.toName);
      // final splashLocation = state.namedLocation(APP_PAGE.splash.toName);
      // final onboardLocation = state.namedLocation(APP_PAGE.onBoarding.toName);
      //
      // final isLogedIn = appService.loginState;
      // final isInitialized = appService.initialized;
      // final isOnboarded = appService.onboarding;
      //
      // final isGoingToLogin = state.subloc == loginLocation;
      // final isGoingToInit = state.subloc == splashLocation;
      // final isGoingToOnboard = state.subloc == onboardLocation;
      //
      // // If not Initialized and not going to Initialized redirect to Splash
      // if (!isInitialized && !isGoingToInit) {
      //   return splashLocation;
      //   // If not onboard and not going to onboard redirect to OnBoarding
      // } else if (isInitialized && !isOnboarded && !isGoingToOnboard) {
      //   return onboardLocation;
      //   // If not logedin and not going to login redirect to Login
      // } else if (isInitialized && isOnboarded && !isLogedIn && !isGoingToLogin) {
      //   return loginLocation;
      //   // If all the scenarios are cleared but still going to any of that screen redirect to Home
      // } else if ((isLogedIn && isGoingToLogin) ||
      //     (isInitialized && isGoingToInit) ||
      //     (isOnboarded && isGoingToOnboard)) {
      //   return homeLocation;
      // } else {
      //   // Else Don't do anything
      //   return null;
      // }
    },
  );

  late final navigatorKey = router.routerDelegate.navigatorKey;
}
