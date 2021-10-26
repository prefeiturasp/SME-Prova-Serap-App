import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/ui/views/home/home.view.dart';
import 'package:appserap/ui/views/login/login.view.dart';
import 'package:appserap/ui/views/orientacao_inicial/orientacao_inicial.view.dart';
import 'package:appserap/ui/views/prova/prova.view.dart';
import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreenView());

      case '/orientacao-inicial':
        return MaterialPageRoute(builder: (_) => OrientacaoInicialView());

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginView());

      case '/home':
        return MaterialPageRoute(builder: (_) => HomeView());

      case '/prova':
        return MaterialPageRoute(builder: (_) => ProvaView(provaStore: args as ProvaStore));

      default:
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      );
    });
  }
}
