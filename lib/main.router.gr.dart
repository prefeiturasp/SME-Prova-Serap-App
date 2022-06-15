// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i17;

import 'dtos/admin_prova_resumo.response.dto.dart' as _i18;
import 'ui/views/admin/home.admin.view.dart' as _i6;
import 'ui/views/admin/prova_contexto.admin.dart' as _i13;
import 'ui/views/admin/prova_questao.admin.view.dart' as _i16;
import 'ui/views/admin/prova_resumo.admin.view.dart' as _i15;
import 'ui/views/admin/prova_resumo_caderno.admin.view.dart' as _i14;
import 'ui/views/home/home.view.dart' as _i4;
import 'ui/views/login/login.adm.view.dart' as _i7;
import 'ui/views/login/login.view.dart' as _i2;
import 'ui/views/orientacao_inicial/orientacao_inicial.view.dart' as _i3;
import 'ui/views/prova/contexto_prova.view.dart' as _i9;
import 'ui/views/prova/prova.view.dart' as _i8;
import 'ui/views/prova/questao.view.dart' as _i10;
import 'ui/views/prova/questao_revisao.view.dart' as _i12;
import 'ui/views/prova/resumo_respostas.view.dart' as _i11;
import 'ui/views/splashscreen/splash_screen.view.dart' as _i1;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i17.GlobalKey<_i17.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    SplashScreenViewRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SplashScreenView());
    },
    LoginViewRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.LoginView());
    },
    OrientacaoInicialViewRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.OrientacaoInicialView());
    },
    HomeViewRoute.name: (routeData) {
      final args = routeData.argsAs<HomeViewRouteArgs>(
          orElse: () => const HomeViewRouteArgs());
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: _i4.HomeView(key: args.key));
    },
    EmptyRouterPageRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.EmptyRouterPage());
    },
    HomeAdminViewRoute.name: (routeData) {
      final args = routeData.argsAs<HomeAdminViewRouteArgs>(
          orElse: () => const HomeAdminViewRouteArgs());
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: _i6.HomeAdminView(key: args.key));
    },
    LoginAdmViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LoginAdmViewRouteArgs>(
          orElse: () =>
              LoginAdmViewRouteArgs(codigo: pathParams.getString('codigo')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.LoginAdmView(key: args.key, codigo: args.codigo));
    },
    ProvaViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProvaViewRouteArgs>(
          orElse: () =>
              ProvaViewRouteArgs(idProva: pathParams.getInt('idProva')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: _i8.ProvaView(idProva: args.idProva));
    },
    ContextoProvaViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ContextoProvaViewRouteArgs>(
          orElse: () => ContextoProvaViewRouteArgs(
              idProva: pathParams.getInt('idProva')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.ContextoProvaView(idProva: args.idProva));
    },
    QuestaoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<QuestaoViewRouteArgs>(
          orElse: () => QuestaoViewRouteArgs(
              idProva: pathParams.getInt('idProva'),
              ordem: pathParams.getInt('ordem')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i10.QuestaoView(
              key: args.key, idProva: args.idProva, ordem: args.ordem));
    },
    ResumoRespostasViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ResumoRespostasViewRouteArgs>(
          orElse: () => ResumoRespostasViewRouteArgs(
              idProva: pathParams.getInt('idProva')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i11.ResumoRespostasView(idProva: args.idProva));
    },
    QuestaoRevisaoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<QuestaoRevisaoViewRouteArgs>(
          orElse: () => QuestaoRevisaoViewRouteArgs(
              idProva: pathParams.getInt('idProva'),
              ordem: pathParams.getInt('ordem')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i12.QuestaoRevisaoView(
              key: args.key, idProva: args.idProva, ordem: args.ordem));
    },
    AdminProvaContextoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<AdminProvaContextoViewRouteArgs>(
          orElse: () => AdminProvaContextoViewRouteArgs(
              idProva: pathParams.getInt('idProva'),
              possuiBIB: queryParams.getBool('possuiBIB', false)));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i13.AdminProvaContextoView(
              key: args.key, idProva: args.idProva, possuiBIB: args.possuiBIB));
    },
    AdminProvaCadernoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminProvaCadernoViewRouteArgs>(
          orElse: () => AdminProvaCadernoViewRouteArgs(
              idProva: pathParams.getInt('idProva')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              _i14.AdminProvaCadernoView(key: args.key, idProva: args.idProva));
    },
    AdminProvaResumoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminProvaResumoViewRouteArgs>(
          orElse: () => AdminProvaResumoViewRouteArgs(
              idProva: pathParams.getInt('idProva'),
              nomeCaderno: pathParams.optString('nomeCaderno')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i15.AdminProvaResumoView(
              key: args.key,
              idProva: args.idProva,
              nomeCaderno: args.nomeCaderno));
    },
    AdminProvaQuestaoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final queryParams = routeData.queryParams;
      final args = routeData.argsAs<AdminProvaQuestaoViewRouteArgs>(
          orElse: () => AdminProvaQuestaoViewRouteArgs(
              idProva: pathParams.getInt('idProva'),
              nomeCaderno: pathParams.optString('nomeCaderno'),
              ordem: pathParams.getInt('ordem'),
              resumo: queryParams.get('resumo', const [])));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i16.AdminProvaQuestaoView(
              key: args.key,
              idProva: args.idProva,
              nomeCaderno: args.nomeCaderno,
              ordem: args.ordem,
              resumo: args.resumo));
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(SplashScreenViewRoute.name, path: '/'),
        _i5.RouteConfig(LoginViewRoute.name, path: '/login', children: [
          _i5.RouteConfig(LoginAdmViewRoute.name,
              path: 'admin/:codigo', parent: LoginViewRoute.name)
        ]),
        _i5.RouteConfig(OrientacaoInicialViewRoute.name, path: '/boasVindas'),
        _i5.RouteConfig(HomeViewRoute.name, path: '/home'),
        _i5.RouteConfig(EmptyRouterPageRoute.name, path: '/prova', children: [
          _i5.RouteConfig(ProvaViewRoute.name,
              path: ':idProva', parent: EmptyRouterPageRoute.name),
          _i5.RouteConfig(ContextoProvaViewRoute.name,
              path: ':idProva/contexto', parent: EmptyRouterPageRoute.name),
          _i5.RouteConfig(QuestaoViewRoute.name,
              path: ':idProva/questao/:ordem',
              parent: EmptyRouterPageRoute.name),
          _i5.RouteConfig(ResumoRespostasViewRoute.name,
              path: ':idProva/resumo', parent: EmptyRouterPageRoute.name),
          _i5.RouteConfig(QuestaoRevisaoViewRoute.name,
              path: ':idProva/revisao/:ordem',
              parent: EmptyRouterPageRoute.name)
        ]),
        _i5.RouteConfig(HomeAdminViewRoute.name, path: '/admin', children: [
          _i5.RouteConfig(AdminProvaContextoViewRoute.name,
              path: 'prova/:idProva/contexto', parent: HomeAdminViewRoute.name),
          _i5.RouteConfig(AdminProvaCadernoViewRoute.name,
              path: 'prova/:idProva/caderno', parent: HomeAdminViewRoute.name),
          _i5.RouteConfig(AdminProvaResumoViewRoute.name,
              path: 'prova/:idProva/caderno/:nomeCaderno/resumo',
              parent: HomeAdminViewRoute.name),
          _i5.RouteConfig(AdminProvaQuestaoViewRoute.name,
              path: 'prova/:idProva/caderno/:nomeCaderno/questao/:ordem',
              parent: HomeAdminViewRoute.name)
        ]),
        _i5.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.SplashScreenView]
class SplashScreenViewRoute extends _i5.PageRouteInfo<void> {
  const SplashScreenViewRoute() : super(SplashScreenViewRoute.name, path: '/');

  static const String name = 'SplashScreenViewRoute';
}

/// generated route for
/// [_i2.LoginView]
class LoginViewRoute extends _i5.PageRouteInfo<void> {
  const LoginViewRoute({List<_i5.PageRouteInfo>? children})
      : super(LoginViewRoute.name, path: '/login', initialChildren: children);

  static const String name = 'LoginViewRoute';
}

/// generated route for
/// [_i3.OrientacaoInicialView]
class OrientacaoInicialViewRoute extends _i5.PageRouteInfo<void> {
  const OrientacaoInicialViewRoute()
      : super(OrientacaoInicialViewRoute.name, path: '/boasVindas');

  static const String name = 'OrientacaoInicialViewRoute';
}

/// generated route for
/// [_i4.HomeView]
class HomeViewRoute extends _i5.PageRouteInfo<HomeViewRouteArgs> {
  HomeViewRoute({_i17.Key? key})
      : super(HomeViewRoute.name,
            path: '/home', args: HomeViewRouteArgs(key: key));

  static const String name = 'HomeViewRoute';
}

class HomeViewRouteArgs {
  const HomeViewRouteArgs({this.key});

  final _i17.Key? key;

  @override
  String toString() {
    return 'HomeViewRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.EmptyRouterPage]
class EmptyRouterPageRoute extends _i5.PageRouteInfo<void> {
  const EmptyRouterPageRoute({List<_i5.PageRouteInfo>? children})
      : super(EmptyRouterPageRoute.name,
            path: '/prova', initialChildren: children);

  static const String name = 'EmptyRouterPageRoute';
}

/// generated route for
/// [_i6.HomeAdminView]
class HomeAdminViewRoute extends _i5.PageRouteInfo<HomeAdminViewRouteArgs> {
  HomeAdminViewRoute({_i17.Key? key, List<_i5.PageRouteInfo>? children})
      : super(HomeAdminViewRoute.name,
            path: '/admin',
            args: HomeAdminViewRouteArgs(key: key),
            initialChildren: children);

  static const String name = 'HomeAdminViewRoute';
}

class HomeAdminViewRouteArgs {
  const HomeAdminViewRouteArgs({this.key});

  final _i17.Key? key;

  @override
  String toString() {
    return 'HomeAdminViewRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i7.LoginAdmView]
class LoginAdmViewRoute extends _i5.PageRouteInfo<LoginAdmViewRouteArgs> {
  LoginAdmViewRoute({_i17.Key? key, required String codigo})
      : super(LoginAdmViewRoute.name,
            path: 'admin/:codigo',
            args: LoginAdmViewRouteArgs(key: key, codigo: codigo),
            rawPathParams: {'codigo': codigo});

  static const String name = 'LoginAdmViewRoute';
}

class LoginAdmViewRouteArgs {
  const LoginAdmViewRouteArgs({this.key, required this.codigo});

  final _i17.Key? key;

  final String codigo;

  @override
  String toString() {
    return 'LoginAdmViewRouteArgs{key: $key, codigo: $codigo}';
  }
}

/// generated route for
/// [_i8.ProvaView]
class ProvaViewRoute extends _i5.PageRouteInfo<ProvaViewRouteArgs> {
  ProvaViewRoute({required int idProva})
      : super(ProvaViewRoute.name,
            path: ':idProva',
            args: ProvaViewRouteArgs(idProva: idProva),
            rawPathParams: {'idProva': idProva});

  static const String name = 'ProvaViewRoute';
}

class ProvaViewRouteArgs {
  const ProvaViewRouteArgs({required this.idProva});

  final int idProva;

  @override
  String toString() {
    return 'ProvaViewRouteArgs{idProva: $idProva}';
  }
}

/// generated route for
/// [_i9.ContextoProvaView]
class ContextoProvaViewRoute
    extends _i5.PageRouteInfo<ContextoProvaViewRouteArgs> {
  ContextoProvaViewRoute({required int idProva})
      : super(ContextoProvaViewRoute.name,
            path: ':idProva/contexto',
            args: ContextoProvaViewRouteArgs(idProva: idProva),
            rawPathParams: {'idProva': idProva});

  static const String name = 'ContextoProvaViewRoute';
}

class ContextoProvaViewRouteArgs {
  const ContextoProvaViewRouteArgs({required this.idProva});

  final int idProva;

  @override
  String toString() {
    return 'ContextoProvaViewRouteArgs{idProva: $idProva}';
  }
}

/// generated route for
/// [_i10.QuestaoView]
class QuestaoViewRoute extends _i5.PageRouteInfo<QuestaoViewRouteArgs> {
  QuestaoViewRoute({_i17.Key? key, required int idProva, required int ordem})
      : super(QuestaoViewRoute.name,
            path: ':idProva/questao/:ordem',
            args:
                QuestaoViewRouteArgs(key: key, idProva: idProva, ordem: ordem),
            rawPathParams: {'idProva': idProva, 'ordem': ordem});

  static const String name = 'QuestaoViewRoute';
}

class QuestaoViewRouteArgs {
  const QuestaoViewRouteArgs(
      {this.key, required this.idProva, required this.ordem});

  final _i17.Key? key;

  final int idProva;

  final int ordem;

  @override
  String toString() {
    return 'QuestaoViewRouteArgs{key: $key, idProva: $idProva, ordem: $ordem}';
  }
}

/// generated route for
/// [_i11.ResumoRespostasView]
class ResumoRespostasViewRoute
    extends _i5.PageRouteInfo<ResumoRespostasViewRouteArgs> {
  ResumoRespostasViewRoute({required int idProva})
      : super(ResumoRespostasViewRoute.name,
            path: ':idProva/resumo',
            args: ResumoRespostasViewRouteArgs(idProva: idProva),
            rawPathParams: {'idProva': idProva});

  static const String name = 'ResumoRespostasViewRoute';
}

class ResumoRespostasViewRouteArgs {
  const ResumoRespostasViewRouteArgs({required this.idProva});

  final int idProva;

  @override
  String toString() {
    return 'ResumoRespostasViewRouteArgs{idProva: $idProva}';
  }
}

/// generated route for
/// [_i12.QuestaoRevisaoView]
class QuestaoRevisaoViewRoute
    extends _i5.PageRouteInfo<QuestaoRevisaoViewRouteArgs> {
  QuestaoRevisaoViewRoute(
      {_i17.Key? key, required int idProva, required int ordem})
      : super(QuestaoRevisaoViewRoute.name,
            path: ':idProva/revisao/:ordem',
            args: QuestaoRevisaoViewRouteArgs(
                key: key, idProva: idProva, ordem: ordem),
            rawPathParams: {'idProva': idProva, 'ordem': ordem});

  static const String name = 'QuestaoRevisaoViewRoute';
}

class QuestaoRevisaoViewRouteArgs {
  const QuestaoRevisaoViewRouteArgs(
      {this.key, required this.idProva, required this.ordem});

  final _i17.Key? key;

  final int idProva;

  final int ordem;

  @override
  String toString() {
    return 'QuestaoRevisaoViewRouteArgs{key: $key, idProva: $idProva, ordem: $ordem}';
  }
}

/// generated route for
/// [_i13.AdminProvaContextoView]
class AdminProvaContextoViewRoute
    extends _i5.PageRouteInfo<AdminProvaContextoViewRouteArgs> {
  AdminProvaContextoViewRoute(
      {_i17.Key? key, required int idProva, bool possuiBIB = false})
      : super(AdminProvaContextoViewRoute.name,
            path: 'prova/:idProva/contexto',
            args: AdminProvaContextoViewRouteArgs(
                key: key, idProva: idProva, possuiBIB: possuiBIB),
            rawPathParams: {'idProva': idProva},
            rawQueryParams: {'possuiBIB': possuiBIB});

  static const String name = 'AdminProvaContextoViewRoute';
}

class AdminProvaContextoViewRouteArgs {
  const AdminProvaContextoViewRouteArgs(
      {this.key, required this.idProva, this.possuiBIB = false});

  final _i17.Key? key;

  final int idProva;

  final bool possuiBIB;

  @override
  String toString() {
    return 'AdminProvaContextoViewRouteArgs{key: $key, idProva: $idProva, possuiBIB: $possuiBIB}';
  }
}

/// generated route for
/// [_i14.AdminProvaCadernoView]
class AdminProvaCadernoViewRoute
    extends _i5.PageRouteInfo<AdminProvaCadernoViewRouteArgs> {
  AdminProvaCadernoViewRoute({_i17.Key? key, required int idProva})
      : super(AdminProvaCadernoViewRoute.name,
            path: 'prova/:idProva/caderno',
            args: AdminProvaCadernoViewRouteArgs(key: key, idProva: idProva),
            rawPathParams: {'idProva': idProva});

  static const String name = 'AdminProvaCadernoViewRoute';
}

class AdminProvaCadernoViewRouteArgs {
  const AdminProvaCadernoViewRouteArgs({this.key, required this.idProva});

  final _i17.Key? key;

  final int idProva;

  @override
  String toString() {
    return 'AdminProvaCadernoViewRouteArgs{key: $key, idProva: $idProva}';
  }
}

/// generated route for
/// [_i15.AdminProvaResumoView]
class AdminProvaResumoViewRoute
    extends _i5.PageRouteInfo<AdminProvaResumoViewRouteArgs> {
  AdminProvaResumoViewRoute(
      {_i17.Key? key, required int idProva, required String? nomeCaderno})
      : super(AdminProvaResumoViewRoute.name,
            path: 'prova/:idProva/caderno/:nomeCaderno/resumo',
            args: AdminProvaResumoViewRouteArgs(
                key: key, idProva: idProva, nomeCaderno: nomeCaderno),
            rawPathParams: {'idProva': idProva, 'nomeCaderno': nomeCaderno});

  static const String name = 'AdminProvaResumoViewRoute';
}

class AdminProvaResumoViewRouteArgs {
  const AdminProvaResumoViewRouteArgs(
      {this.key, required this.idProva, required this.nomeCaderno});

  final _i17.Key? key;

  final int idProva;

  final String? nomeCaderno;

  @override
  String toString() {
    return 'AdminProvaResumoViewRouteArgs{key: $key, idProva: $idProva, nomeCaderno: $nomeCaderno}';
  }
}

/// generated route for
/// [_i16.AdminProvaQuestaoView]
class AdminProvaQuestaoViewRoute
    extends _i5.PageRouteInfo<AdminProvaQuestaoViewRouteArgs> {
  AdminProvaQuestaoViewRoute(
      {_i17.Key? key,
      required int idProva,
      String? nomeCaderno,
      required int ordem,
      List<_i18.AdminProvaResumoResponseDTO> resumo = const []})
      : super(AdminProvaQuestaoViewRoute.name,
            path: 'prova/:idProva/caderno/:nomeCaderno/questao/:ordem',
            args: AdminProvaQuestaoViewRouteArgs(
                key: key,
                idProva: idProva,
                nomeCaderno: nomeCaderno,
                ordem: ordem,
                resumo: resumo),
            rawPathParams: {
              'idProva': idProva,
              'nomeCaderno': nomeCaderno,
              'ordem': ordem
            },
            rawQueryParams: {
              'resumo': resumo
            });

  static const String name = 'AdminProvaQuestaoViewRoute';
}

class AdminProvaQuestaoViewRouteArgs {
  const AdminProvaQuestaoViewRouteArgs(
      {this.key,
      required this.idProva,
      this.nomeCaderno,
      required this.ordem,
      this.resumo = const []});

  final _i17.Key? key;

  final int idProva;

  final String? nomeCaderno;

  final int ordem;

  final List<_i18.AdminProvaResumoResponseDTO> resumo;

  @override
  String toString() {
    return 'AdminProvaQuestaoViewRouteArgs{key: $key, idProva: $idProva, nomeCaderno: $nomeCaderno, ordem: $ordem, resumo: $resumo}';
  }
}
