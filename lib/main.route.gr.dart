// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:appserap/ui/views/admin/home.admin.view.dart' as _i7;
import 'package:appserap/ui/views/admin/prova_contexto.admin.dart' as _i2;
import 'package:appserap/ui/views/admin/prova_questao.admin.view.dart' as _i3;
import 'package:appserap/ui/views/admin/prova_resumo.admin.view.dart' as _i4;
import 'package:appserap/ui/views/admin/prova_resumo_caderno.admin.view.dart'
    as _i1;
import 'package:appserap/ui/views/error/error.view.dart' as _i6;
import 'package:appserap/ui/views/home/home.view.dart' as _i8;
import 'package:appserap/ui/views/login/login.adm.view.dart' as _i9;
import 'package:appserap/ui/views/login/login.view.dart' as _i10;
import 'package:appserap/ui/views/orientacao_inicial/orientacao_inicial.view.dart'
    as _i11;
import 'package:appserap/ui/views/prova/contexto_prova.view.dart' as _i5;
import 'package:appserap/ui/views/prova/prova.view.dart' as _i14;
import 'package:appserap/ui/views/prova/questao.view.dart' as _i18;
import 'package:appserap/ui/views/prova/questao_revisao.view.dart' as _i16;
import 'package:appserap/ui/views/prova/resumo_respostas.view.dart' as _i19;
import 'package:appserap/ui/views/prova_resultado/prova_resultado_resumo.view.dart'
    as _i12;
import 'package:appserap/ui/views/prova_resultado/questao_resultado_detalhe.view.dart'
    as _i15;
import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart' as _i21;
import 'package:appserap/ui/views/tai/prova_tai.view.dart' as _i13;
import 'package:appserap/ui/views/tai/questao_tai.view.dart' as _i17;
import 'package:appserap/ui/views/tai/resumo_tai.view.dart' as _i20;
import 'package:auto_route/auto_route.dart' as _i22;
import 'package:flutter/foundation.dart' as _i24;
import 'package:flutter/material.dart' as _i23;

abstract class $AppRouter extends _i22.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i22.PageFactory> pagesMap = {
    AdminProvaCadernoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminProvaCadernoViewRouteArgs>(
          orElse: () => AdminProvaCadernoViewRouteArgs(
              idProva: pathParams.getInt('idProva')));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AdminProvaCadernoView(
          key: args.key,
          idProva: args.idProva,
        ),
      );
    },
    AdminProvaContextoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminProvaContextoViewRouteArgs>(
          orElse: () => AdminProvaContextoViewRouteArgs(
                idProva: pathParams.getInt('idProva'),
                possuiBIB: pathParams.getBool('possuiBIB'),
              ));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.AdminProvaContextoView(
          key: args.key,
          idProva: args.idProva,
          possuiBIB: args.possuiBIB,
        ),
      );
    },
    AdminProvaQuestaoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminProvaQuestaoViewRouteArgs>(
          orElse: () => AdminProvaQuestaoViewRouteArgs(
                idProva: pathParams.getInt('idProva'),
                nomeCaderno: pathParams.optString('nomeCaderno'),
                ordem: pathParams.getInt('ordem'),
              ));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.AdminProvaQuestaoView(
          key: args.key,
          idProva: args.idProva,
          nomeCaderno: args.nomeCaderno,
          ordem: args.ordem,
        ),
      );
    },
    AdminProvaResumoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AdminProvaResumoViewRouteArgs>(
          orElse: () => AdminProvaResumoViewRouteArgs(
                idProva: pathParams.getInt('idProva'),
                nomeCaderno: pathParams.optString('nomeCaderno'),
              ));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.AdminProvaResumoView(
          key: args.key,
          idProva: args.idProva,
          nomeCaderno: args.nomeCaderno,
        ),
      );
    },
    ContextoProvaViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ContextoProvaViewRouteArgs>(
          orElse: () => ContextoProvaViewRouteArgs(
              idProva: pathParams.getInt('idProva')));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ContextoProvaView(
          key: args.key,
          idProva: args.idProva,
        ),
      );
    },
    ErrorPageRoute.name: (routeData) {
      final args = routeData.argsAs<ErrorPageRouteArgs>(
          orElse: () => const ErrorPageRouteArgs());
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.ErrorPage(
          key: args.key,
          error: args.error,
        ),
      );
    },
    HomeAdminViewRoute.name: (routeData) {
      final args = routeData.argsAs<HomeAdminViewRouteArgs>(
          orElse: () => const HomeAdminViewRouteArgs());
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.HomeAdminView(key: args.key),
      );
    },
    HomeViewRoute.name: (routeData) {
      final args = routeData.argsAs<HomeViewRouteArgs>(
          orElse: () => const HomeViewRouteArgs());
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.HomeView(key: args.key),
      );
    },
    LoginAdmViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LoginAdmViewRouteArgs>(
          orElse: () =>
              LoginAdmViewRouteArgs(codigo: pathParams.getString('codigo')));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.LoginAdmView(
          key: args.key,
          codigo: args.codigo,
        ),
      );
    },
    LoginViewRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.LoginView(),
      );
    },
    OrientacaoInicialViewRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.OrientacaoInicialView(),
      );
    },
    ProvaResultadoResumoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProvaResultadoResumoViewRouteArgs>(
          orElse: () => ProvaResultadoResumoViewRouteArgs(
                provaId: pathParams.getInt('idProva'),
                caderno: pathParams.getString('caderno'),
              ));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.ProvaResultadoResumoView(
          key: args.key,
          provaId: args.provaId,
          caderno: args.caderno,
        ),
      );
    },
    ProvaTaiViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProvaTaiViewRouteArgs>(
          orElse: () =>
              ProvaTaiViewRouteArgs(provaId: pathParams.getInt('idProva')));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.ProvaTaiView(
          key: args.key,
          provaId: args.provaId,
        ),
      );
    },
    ProvaViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProvaViewRouteArgs>(
          orElse: () =>
              ProvaViewRouteArgs(idProva: pathParams.getInt('idProva')));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.ProvaView(
          key: args.key,
          idProva: args.idProva,
        ),
      );
    },
    QuestaoResultadoDetalhesViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<QuestaoResultadoDetalhesViewRouteArgs>(
          orElse: () => QuestaoResultadoDetalhesViewRouteArgs(
                provaId: pathParams.getInt('idProva'),
                caderno: pathParams.getString('caderno'),
                ordem: pathParams.getInt('ordem'),
              ));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.QuestaoResultadoDetalhesView(
          key: args.key,
          provaId: args.provaId,
          caderno: args.caderno,
          ordem: args.ordem,
        ),
      );
    },
    QuestaoRevisaoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<QuestaoRevisaoViewRouteArgs>(
          orElse: () => QuestaoRevisaoViewRouteArgs(
                idProva: pathParams.getInt('idProva'),
                ordem: pathParams.getInt('ordem'),
              ));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.QuestaoRevisaoView(
          key: args.key,
          idProva: args.idProva,
          ordem: args.ordem,
        ),
      );
    },
    QuestaoTaiViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<QuestaoTaiViewRouteArgs>(
          orElse: () => QuestaoTaiViewRouteArgs(
                provaId: pathParams.getInt('idProva'),
                ordem: pathParams.getInt('ordem'),
              ));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i17.QuestaoTaiView(
          key: args.key,
          provaId: args.provaId,
          ordem: args.ordem,
        ),
      );
    },
    QuestaoViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<QuestaoViewRouteArgs>(
          orElse: () => QuestaoViewRouteArgs(
                idProva: pathParams.getInt('idProva'),
                ordem: pathParams.getInt('ordem'),
              ));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.QuestaoView(
          key: args.key,
          idProva: args.idProva,
          ordem: args.ordem,
        ),
      );
    },
    ResumoRespostasViewRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ResumoRespostasViewRouteArgs>(
          orElse: () => ResumoRespostasViewRouteArgs(
              idProva: pathParams.getInt('idProva')));
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i19.ResumoRespostasView(
          key: args.key,
          idProva: args.idProva,
        ),
      );
    },
    ResumoTaiViewRoute.name: (routeData) {
      final args = routeData.argsAs<ResumoTaiViewRouteArgs>();
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i20.ResumoTaiView(
          key: args.key,
          provaId: args.provaId,
        ),
      );
    },
    SplashScreenViewRoute.name: (routeData) {
      return _i22.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.SplashScreenView(),
      );
    },
  };
}

/// generated route for
/// [_i1.AdminProvaCadernoView]
class AdminProvaCadernoViewRoute
    extends _i22.PageRouteInfo<AdminProvaCadernoViewRouteArgs> {
  AdminProvaCadernoViewRoute({
    _i23.Key? key,
    required int idProva,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          AdminProvaCadernoViewRoute.name,
          args: AdminProvaCadernoViewRouteArgs(
            key: key,
            idProva: idProva,
          ),
          rawPathParams: {'idProva': idProva},
          initialChildren: children,
        );

  static const String name = 'AdminProvaCadernoViewRoute';

  static const _i22.PageInfo<AdminProvaCadernoViewRouteArgs> page =
      _i22.PageInfo<AdminProvaCadernoViewRouteArgs>(name);
}

class AdminProvaCadernoViewRouteArgs {
  const AdminProvaCadernoViewRouteArgs({
    this.key,
    required this.idProva,
  });

  final _i23.Key? key;

  final int idProva;

  @override
  String toString() {
    return 'AdminProvaCadernoViewRouteArgs{key: $key, idProva: $idProva}';
  }
}

/// generated route for
/// [_i2.AdminProvaContextoView]
class AdminProvaContextoViewRoute
    extends _i22.PageRouteInfo<AdminProvaContextoViewRouteArgs> {
  AdminProvaContextoViewRoute({
    _i24.Key? key,
    required int idProva,
    required bool possuiBIB,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          AdminProvaContextoViewRoute.name,
          args: AdminProvaContextoViewRouteArgs(
            key: key,
            idProva: idProva,
            possuiBIB: possuiBIB,
          ),
          rawPathParams: {
            'idProva': idProva,
            'possuiBIB': possuiBIB,
          },
          initialChildren: children,
        );

  static const String name = 'AdminProvaContextoViewRoute';

  static const _i22.PageInfo<AdminProvaContextoViewRouteArgs> page =
      _i22.PageInfo<AdminProvaContextoViewRouteArgs>(name);
}

class AdminProvaContextoViewRouteArgs {
  const AdminProvaContextoViewRouteArgs({
    this.key,
    required this.idProva,
    required this.possuiBIB,
  });

  final _i24.Key? key;

  final int idProva;

  final bool possuiBIB;

  @override
  String toString() {
    return 'AdminProvaContextoViewRouteArgs{key: $key, idProva: $idProva, possuiBIB: $possuiBIB}';
  }
}

/// generated route for
/// [_i3.AdminProvaQuestaoView]
class AdminProvaQuestaoViewRoute
    extends _i22.PageRouteInfo<AdminProvaQuestaoViewRouteArgs> {
  AdminProvaQuestaoViewRoute({
    _i23.Key? key,
    required int idProva,
    String? nomeCaderno,
    required int ordem,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          AdminProvaQuestaoViewRoute.name,
          args: AdminProvaQuestaoViewRouteArgs(
            key: key,
            idProva: idProva,
            nomeCaderno: nomeCaderno,
            ordem: ordem,
          ),
          rawPathParams: {
            'idProva': idProva,
            'nomeCaderno': nomeCaderno,
            'ordem': ordem,
          },
          initialChildren: children,
        );

  static const String name = 'AdminProvaQuestaoViewRoute';

  static const _i22.PageInfo<AdminProvaQuestaoViewRouteArgs> page =
      _i22.PageInfo<AdminProvaQuestaoViewRouteArgs>(name);
}

class AdminProvaQuestaoViewRouteArgs {
  const AdminProvaQuestaoViewRouteArgs({
    this.key,
    required this.idProva,
    this.nomeCaderno,
    required this.ordem,
  });

  final _i23.Key? key;

  final int idProva;

  final String? nomeCaderno;

  final int ordem;

  @override
  String toString() {
    return 'AdminProvaQuestaoViewRouteArgs{key: $key, idProva: $idProva, nomeCaderno: $nomeCaderno, ordem: $ordem}';
  }
}

/// generated route for
/// [_i4.AdminProvaResumoView]
class AdminProvaResumoViewRoute
    extends _i22.PageRouteInfo<AdminProvaResumoViewRouteArgs> {
  AdminProvaResumoViewRoute({
    _i23.Key? key,
    required int idProva,
    String? nomeCaderno,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          AdminProvaResumoViewRoute.name,
          args: AdminProvaResumoViewRouteArgs(
            key: key,
            idProva: idProva,
            nomeCaderno: nomeCaderno,
          ),
          rawPathParams: {
            'idProva': idProva,
            'nomeCaderno': nomeCaderno,
          },
          initialChildren: children,
        );

  static const String name = 'AdminProvaResumoViewRoute';

  static const _i22.PageInfo<AdminProvaResumoViewRouteArgs> page =
      _i22.PageInfo<AdminProvaResumoViewRouteArgs>(name);
}

class AdminProvaResumoViewRouteArgs {
  const AdminProvaResumoViewRouteArgs({
    this.key,
    required this.idProva,
    this.nomeCaderno,
  });

  final _i23.Key? key;

  final int idProva;

  final String? nomeCaderno;

  @override
  String toString() {
    return 'AdminProvaResumoViewRouteArgs{key: $key, idProva: $idProva, nomeCaderno: $nomeCaderno}';
  }
}

/// generated route for
/// [_i5.ContextoProvaView]
class ContextoProvaViewRoute
    extends _i22.PageRouteInfo<ContextoProvaViewRouteArgs> {
  ContextoProvaViewRoute({
    _i24.Key? key,
    required int idProva,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          ContextoProvaViewRoute.name,
          args: ContextoProvaViewRouteArgs(
            key: key,
            idProva: idProva,
          ),
          rawPathParams: {'idProva': idProva},
          initialChildren: children,
        );

  static const String name = 'ContextoProvaViewRoute';

  static const _i22.PageInfo<ContextoProvaViewRouteArgs> page =
      _i22.PageInfo<ContextoProvaViewRouteArgs>(name);
}

class ContextoProvaViewRouteArgs {
  const ContextoProvaViewRouteArgs({
    this.key,
    required this.idProva,
  });

  final _i24.Key? key;

  final int idProva;

  @override
  String toString() {
    return 'ContextoProvaViewRouteArgs{key: $key, idProva: $idProva}';
  }
}

/// generated route for
/// [_i6.ErrorPage]
class ErrorPageRoute extends _i22.PageRouteInfo<ErrorPageRouteArgs> {
  ErrorPageRoute({
    _i23.Key? key,
    String? error,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          ErrorPageRoute.name,
          args: ErrorPageRouteArgs(
            key: key,
            error: error,
          ),
          initialChildren: children,
        );

  static const String name = 'ErrorPageRoute';

  static const _i22.PageInfo<ErrorPageRouteArgs> page =
      _i22.PageInfo<ErrorPageRouteArgs>(name);
}

class ErrorPageRouteArgs {
  const ErrorPageRouteArgs({
    this.key,
    this.error,
  });

  final _i23.Key? key;

  final String? error;

  @override
  String toString() {
    return 'ErrorPageRouteArgs{key: $key, error: $error}';
  }
}

/// generated route for
/// [_i7.HomeAdminView]
class HomeAdminViewRoute extends _i22.PageRouteInfo<HomeAdminViewRouteArgs> {
  HomeAdminViewRoute({
    _i23.Key? key,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          HomeAdminViewRoute.name,
          args: HomeAdminViewRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HomeAdminViewRoute';

  static const _i22.PageInfo<HomeAdminViewRouteArgs> page =
      _i22.PageInfo<HomeAdminViewRouteArgs>(name);
}

class HomeAdminViewRouteArgs {
  const HomeAdminViewRouteArgs({this.key});

  final _i23.Key? key;

  @override
  String toString() {
    return 'HomeAdminViewRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.HomeView]
class HomeViewRoute extends _i22.PageRouteInfo<HomeViewRouteArgs> {
  HomeViewRoute({
    _i23.Key? key,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          HomeViewRoute.name,
          args: HomeViewRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HomeViewRoute';

  static const _i22.PageInfo<HomeViewRouteArgs> page =
      _i22.PageInfo<HomeViewRouteArgs>(name);
}

class HomeViewRouteArgs {
  const HomeViewRouteArgs({this.key});

  final _i23.Key? key;

  @override
  String toString() {
    return 'HomeViewRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i9.LoginAdmView]
class LoginAdmViewRoute extends _i22.PageRouteInfo<LoginAdmViewRouteArgs> {
  LoginAdmViewRoute({
    _i23.Key? key,
    required String codigo,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          LoginAdmViewRoute.name,
          args: LoginAdmViewRouteArgs(
            key: key,
            codigo: codigo,
          ),
          rawPathParams: {'codigo': codigo},
          initialChildren: children,
        );

  static const String name = 'LoginAdmViewRoute';

  static const _i22.PageInfo<LoginAdmViewRouteArgs> page =
      _i22.PageInfo<LoginAdmViewRouteArgs>(name);
}

class LoginAdmViewRouteArgs {
  const LoginAdmViewRouteArgs({
    this.key,
    required this.codigo,
  });

  final _i23.Key? key;

  final String codigo;

  @override
  String toString() {
    return 'LoginAdmViewRouteArgs{key: $key, codigo: $codigo}';
  }
}

/// generated route for
/// [_i10.LoginView]
class LoginViewRoute extends _i22.PageRouteInfo<void> {
  const LoginViewRoute({List<_i22.PageRouteInfo>? children})
      : super(
          LoginViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginViewRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i11.OrientacaoInicialView]
class OrientacaoInicialViewRoute extends _i22.PageRouteInfo<void> {
  const OrientacaoInicialViewRoute({List<_i22.PageRouteInfo>? children})
      : super(
          OrientacaoInicialViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrientacaoInicialViewRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}

/// generated route for
/// [_i12.ProvaResultadoResumoView]
class ProvaResultadoResumoViewRoute
    extends _i22.PageRouteInfo<ProvaResultadoResumoViewRouteArgs> {
  ProvaResultadoResumoViewRoute({
    _i23.Key? key,
    required int provaId,
    required String caderno,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          ProvaResultadoResumoViewRoute.name,
          args: ProvaResultadoResumoViewRouteArgs(
            key: key,
            provaId: provaId,
            caderno: caderno,
          ),
          rawPathParams: {
            'idProva': provaId,
            'caderno': caderno,
          },
          initialChildren: children,
        );

  static const String name = 'ProvaResultadoResumoViewRoute';

  static const _i22.PageInfo<ProvaResultadoResumoViewRouteArgs> page =
      _i22.PageInfo<ProvaResultadoResumoViewRouteArgs>(name);
}

class ProvaResultadoResumoViewRouteArgs {
  const ProvaResultadoResumoViewRouteArgs({
    this.key,
    required this.provaId,
    required this.caderno,
  });

  final _i23.Key? key;

  final int provaId;

  final String caderno;

  @override
  String toString() {
    return 'ProvaResultadoResumoViewRouteArgs{key: $key, provaId: $provaId, caderno: $caderno}';
  }
}

/// generated route for
/// [_i13.ProvaTaiView]
class ProvaTaiViewRoute extends _i22.PageRouteInfo<ProvaTaiViewRouteArgs> {
  ProvaTaiViewRoute({
    _i23.Key? key,
    required int provaId,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          ProvaTaiViewRoute.name,
          args: ProvaTaiViewRouteArgs(
            key: key,
            provaId: provaId,
          ),
          rawPathParams: {'idProva': provaId},
          initialChildren: children,
        );

  static const String name = 'ProvaTaiViewRoute';

  static const _i22.PageInfo<ProvaTaiViewRouteArgs> page =
      _i22.PageInfo<ProvaTaiViewRouteArgs>(name);
}

class ProvaTaiViewRouteArgs {
  const ProvaTaiViewRouteArgs({
    this.key,
    required this.provaId,
  });

  final _i23.Key? key;

  final int provaId;

  @override
  String toString() {
    return 'ProvaTaiViewRouteArgs{key: $key, provaId: $provaId}';
  }
}

/// generated route for
/// [_i14.ProvaView]
class ProvaViewRoute extends _i22.PageRouteInfo<ProvaViewRouteArgs> {
  ProvaViewRoute({
    _i23.Key? key,
    required int idProva,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          ProvaViewRoute.name,
          args: ProvaViewRouteArgs(
            key: key,
            idProva: idProva,
          ),
          rawPathParams: {'idProva': idProva},
          initialChildren: children,
        );

  static const String name = 'ProvaViewRoute';

  static const _i22.PageInfo<ProvaViewRouteArgs> page =
      _i22.PageInfo<ProvaViewRouteArgs>(name);
}

class ProvaViewRouteArgs {
  const ProvaViewRouteArgs({
    this.key,
    required this.idProva,
  });

  final _i23.Key? key;

  final int idProva;

  @override
  String toString() {
    return 'ProvaViewRouteArgs{key: $key, idProva: $idProva}';
  }
}

/// generated route for
/// [_i15.QuestaoResultadoDetalhesView]
class QuestaoResultadoDetalhesViewRoute
    extends _i22.PageRouteInfo<QuestaoResultadoDetalhesViewRouteArgs> {
  QuestaoResultadoDetalhesViewRoute({
    _i24.Key? key,
    required int provaId,
    required String caderno,
    required int ordem,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          QuestaoResultadoDetalhesViewRoute.name,
          args: QuestaoResultadoDetalhesViewRouteArgs(
            key: key,
            provaId: provaId,
            caderno: caderno,
            ordem: ordem,
          ),
          rawPathParams: {
            'idProva': provaId,
            'caderno': caderno,
            'ordem': ordem,
          },
          initialChildren: children,
        );

  static const String name = 'QuestaoResultadoDetalhesViewRoute';

  static const _i22.PageInfo<QuestaoResultadoDetalhesViewRouteArgs> page =
      _i22.PageInfo<QuestaoResultadoDetalhesViewRouteArgs>(name);
}

class QuestaoResultadoDetalhesViewRouteArgs {
  const QuestaoResultadoDetalhesViewRouteArgs({
    this.key,
    required this.provaId,
    required this.caderno,
    required this.ordem,
  });

  final _i24.Key? key;

  final int provaId;

  final String caderno;

  final int ordem;

  @override
  String toString() {
    return 'QuestaoResultadoDetalhesViewRouteArgs{key: $key, provaId: $provaId, caderno: $caderno, ordem: $ordem}';
  }
}

/// generated route for
/// [_i16.QuestaoRevisaoView]
class QuestaoRevisaoViewRoute
    extends _i22.PageRouteInfo<QuestaoRevisaoViewRouteArgs> {
  QuestaoRevisaoViewRoute({
    _i24.Key? key,
    required int idProva,
    required int ordem,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          QuestaoRevisaoViewRoute.name,
          args: QuestaoRevisaoViewRouteArgs(
            key: key,
            idProva: idProva,
            ordem: ordem,
          ),
          rawPathParams: {
            'idProva': idProva,
            'ordem': ordem,
          },
          initialChildren: children,
        );

  static const String name = 'QuestaoRevisaoViewRoute';

  static const _i22.PageInfo<QuestaoRevisaoViewRouteArgs> page =
      _i22.PageInfo<QuestaoRevisaoViewRouteArgs>(name);
}

class QuestaoRevisaoViewRouteArgs {
  const QuestaoRevisaoViewRouteArgs({
    this.key,
    required this.idProva,
    required this.ordem,
  });

  final _i24.Key? key;

  final int idProva;

  final int ordem;

  @override
  String toString() {
    return 'QuestaoRevisaoViewRouteArgs{key: $key, idProva: $idProva, ordem: $ordem}';
  }
}

/// generated route for
/// [_i17.QuestaoTaiView]
class QuestaoTaiViewRoute extends _i22.PageRouteInfo<QuestaoTaiViewRouteArgs> {
  QuestaoTaiViewRoute({
    _i23.Key? key,
    required int provaId,
    required int ordem,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          QuestaoTaiViewRoute.name,
          args: QuestaoTaiViewRouteArgs(
            key: key,
            provaId: provaId,
            ordem: ordem,
          ),
          rawPathParams: {
            'idProva': provaId,
            'ordem': ordem,
          },
          initialChildren: children,
        );

  static const String name = 'QuestaoTaiViewRoute';

  static const _i22.PageInfo<QuestaoTaiViewRouteArgs> page =
      _i22.PageInfo<QuestaoTaiViewRouteArgs>(name);
}

class QuestaoTaiViewRouteArgs {
  const QuestaoTaiViewRouteArgs({
    this.key,
    required this.provaId,
    required this.ordem,
  });

  final _i23.Key? key;

  final int provaId;

  final int ordem;

  @override
  String toString() {
    return 'QuestaoTaiViewRouteArgs{key: $key, provaId: $provaId, ordem: $ordem}';
  }
}

/// generated route for
/// [_i18.QuestaoView]
class QuestaoViewRoute extends _i22.PageRouteInfo<QuestaoViewRouteArgs> {
  QuestaoViewRoute({
    _i24.Key? key,
    required int idProva,
    required int ordem,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          QuestaoViewRoute.name,
          args: QuestaoViewRouteArgs(
            key: key,
            idProva: idProva,
            ordem: ordem,
          ),
          rawPathParams: {
            'idProva': idProva,
            'ordem': ordem,
          },
          initialChildren: children,
        );

  static const String name = 'QuestaoViewRoute';

  static const _i22.PageInfo<QuestaoViewRouteArgs> page =
      _i22.PageInfo<QuestaoViewRouteArgs>(name);
}

class QuestaoViewRouteArgs {
  const QuestaoViewRouteArgs({
    this.key,
    required this.idProva,
    required this.ordem,
  });

  final _i24.Key? key;

  final int idProva;

  final int ordem;

  @override
  String toString() {
    return 'QuestaoViewRouteArgs{key: $key, idProva: $idProva, ordem: $ordem}';
  }
}

/// generated route for
/// [_i19.ResumoRespostasView]
class ResumoRespostasViewRoute
    extends _i22.PageRouteInfo<ResumoRespostasViewRouteArgs> {
  ResumoRespostasViewRoute({
    _i23.Key? key,
    required int idProva,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          ResumoRespostasViewRoute.name,
          args: ResumoRespostasViewRouteArgs(
            key: key,
            idProva: idProva,
          ),
          rawPathParams: {'idProva': idProva},
          initialChildren: children,
        );

  static const String name = 'ResumoRespostasViewRoute';

  static const _i22.PageInfo<ResumoRespostasViewRouteArgs> page =
      _i22.PageInfo<ResumoRespostasViewRouteArgs>(name);
}

class ResumoRespostasViewRouteArgs {
  const ResumoRespostasViewRouteArgs({
    this.key,
    required this.idProva,
  });

  final _i23.Key? key;

  final int idProva;

  @override
  String toString() {
    return 'ResumoRespostasViewRouteArgs{key: $key, idProva: $idProva}';
  }
}

/// generated route for
/// [_i20.ResumoTaiView]
class ResumoTaiViewRoute extends _i22.PageRouteInfo<ResumoTaiViewRouteArgs> {
  ResumoTaiViewRoute({
    _i23.Key? key,
    required int provaId,
    List<_i22.PageRouteInfo>? children,
  }) : super(
          ResumoTaiViewRoute.name,
          args: ResumoTaiViewRouteArgs(
            key: key,
            provaId: provaId,
          ),
          initialChildren: children,
        );

  static const String name = 'ResumoTaiViewRoute';

  static const _i22.PageInfo<ResumoTaiViewRouteArgs> page =
      _i22.PageInfo<ResumoTaiViewRouteArgs>(name);
}

class ResumoTaiViewRouteArgs {
  const ResumoTaiViewRouteArgs({
    this.key,
    required this.provaId,
  });

  final _i23.Key? key;

  final int provaId;

  @override
  String toString() {
    return 'ResumoTaiViewRouteArgs{key: $key, provaId: $provaId}';
  }
}

/// generated route for
/// [_i21.SplashScreenView]
class SplashScreenViewRoute extends _i22.PageRouteInfo<void> {
  const SplashScreenViewRoute({List<_i22.PageRouteInfo>? children})
      : super(
          SplashScreenViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenViewRoute';

  static const _i22.PageInfo<void> page = _i22.PageInfo<void>(name);
}
