import 'package:auto_route/auto_route.dart';

import 'ui/views/admin/home.admin.view.dart';
import 'ui/views/admin/prova_contexto.admin.dart';
import 'ui/views/admin/prova_questao.admin.view.dart';
import 'ui/views/admin/prova_resumo.admin.view.dart';
import 'ui/views/admin/prova_resumo_caderno.admin.view.dart';
import 'ui/views/home/home.view.dart';
import 'ui/views/login/login.adm.view.dart';
import 'ui/views/login/login.view.dart';
import 'ui/views/orientacao_inicial/orientacao_inicial.view.dart';
import 'ui/views/prova/contexto_prova.view.dart';
import 'ui/views/prova/prova.view.dart';
import 'ui/views/prova/questao.view.dart';
import 'ui/views/prova/questao_revisao.view.dart';
import 'ui/views/prova/resumo_respostas.view.dart';
import 'ui/views/splashscreen/splash_screen.view.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'SERAp Estudantes',
  routes: <AutoRoute>[
    AutoRoute(
      initial: true,
      path: '/',
      page: SplashScreenView,
    ),

    // Login
    AutoRoute(
      path: '/login',
      page: LoginView,
      children: [
        AutoRoute(
          path: 'admin/:codigo',
          page: LoginAdmView,
        ),
      ],
    ),

    // Boas Vindas
    AutoRoute(
      path: '/boasVindas',
      page: OrientacaoInicialView,
    ),

    // Home
    AutoRoute(
      path: '/home',
      page: HomeView,
    ),

    // Prova
    AutoRoute(
      path: '/prova',
      page: EmptyRouterPage,
      children: [
        AutoRoute(
          path: ':idProva',
          page: ProvaView,
        ),
        AutoRoute(
          path: ':idProva/contexto',
          page: ContextoProvaView,
        ),
        AutoRoute(
          path: ':idProva/questao/:ordem',
          page: QuestaoView,
        ),
        AutoRoute(
          path: ':idProva/resumo',
          page: ResumoRespostasView,
        ),
        AutoRoute(
          path: ':idProva/revisao/:ordem',
          page: QuestaoRevisaoView,
        ),
      ],
    ),

    // Admin
    AutoRoute(
      path: '/admin',
      page: HomeAdminView,
      children: [
        AutoRoute(
          path: 'prova/:idProva/contexto',
          page: AdminProvaContextoView,
        ),
        AutoRoute(
          path: 'prova/:idProva/caderno',
          page: AdminProvaCadernoView,
        ),
        // AutoRoute(
        //   path: ':idProva/resumo',
        //   page: AdminProvaResumoView,
        // ),
        AutoRoute(
          path: 'prova/:idProva/caderno/:nomeCaderno/resumo',
          page: AdminProvaResumoView,
        ),
        // AutoRoute(
        //   path: ':idProva/questao/:ordem',
        //   page: AdminProvaQuestaoView,
        // ),
        AutoRoute(
          path: 'prova/:idProva/caderno/:nomeCaderno/questao/:ordem',
          page: AdminProvaQuestaoView,
        ),
      ],
    ),

    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $AppRouter {}
