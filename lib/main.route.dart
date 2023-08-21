import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import 'main.route.gr.dart';

@Singleton()
@AutoRouterConfig(
  replaceInRouteName: 'Page|Screen,Route,View',
)
class AppRouter extends $AppRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashScreenViewRoute.page, path: '/splash', initial: true),

    AutoRoute(page: LoginViewRoute.page, path: '/login'),
    AutoRoute(page: LoginAdmViewRoute.page, path: '/login/admin/:codigo'),
    AutoRoute(page: OrientacaoInicialViewRoute.page, path: '/boasVindas'),

    // Aluno
    AutoRoute(page: HomeViewRoute.page, path: '/home'),
    AutoRoute(page: ProvaViewRoute.page, path: '/prova/:idProva'),
    AutoRoute(page: ContextoProvaViewRoute.page, path: '/prova/:idProva/contexto'),
    AutoRoute(page: QuestaoViewRoute.page, path: '/prova/:idProva/questao/:ordem'),
    AutoRoute(page: ResumoRespostasViewRoute.page, path: '/prova/:idProva/resumo'),
    AutoRoute(page: QuestaoRevisaoViewRoute.page, path: '/prova/:idProva/revisao/:ordem'),

    // Resultado Prova
    AutoRoute(page: ProvaResultadoResumoViewRoute.page, path: '/prova/resposta/:idProva/:nomeCaderno/resumo'),
    AutoRoute(page: QuestaoResultadoDetalhesViewRoute.page, path: '/prova/resposta/:idProva/:nomeCaderno/:ordem/detalhes'),

    // Admin
    AutoRoute(page: HomeAdminViewRoute.page, path: '/admin'),
    AutoRoute(page: AdminProvaContextoViewRoute.page, path: '/admin/prova/:idProva/contexto'),
    AutoRoute(page: AdminProvaCadernoViewRoute.page, path: '/admin/prova/:idProva/caderno'),
    AutoRoute(page: AdminProvaResumoViewRoute.page, path: '/admin/prova/:idProva/caderno/:nomeCaderno/resumo'),
    AutoRoute(page: AdminProvaQuestaoViewRoute.page, path: '/admin/prova/:idProva/questao/:ordem'),
    AutoRoute(page: AdminProvaQuestaoViewRoute.page, path: '/admin/prova/:idProva/caderno/:nomeCaderno/questao/:ordem'),

    // Tai
    AutoRoute(page: ProvaTaiViewRoute.page, path: '/prova/tai/:idProva/carregar'),
    AutoRoute(page: QuestaoTaiViewRoute.page, path: '/prova/tai/:idProva/questao/:ordem'),
    AutoRoute(page: ResumoTaiViewRoute.page, path: '/prova/tai/:idProva/resumo'),

  ];
}