import 'dart:async';

import 'package:appserap/services/notification_service.dart';
import 'package:appserap/views/splash_screen.view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ioc/dependencias.ioc.dart';
import 'utils/app_config.util.dart';

Future initializeAppConfig() async {
  try {
    await AppConfigReader.initialize();
  } catch (error) {
    print("Erro ao ler arquivo de configurações.");
    print("Verifique se seu projeto possui o arquivo config/app_config.json");
    print('$error');
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //String? mensagem = message.notification?.body;
  print('RECEBEU UMA MENSAGEM:');
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("testeMensagem", "RECEBEU UMA MENSAGEM PELO PUSH");

  // final _provaController = GetIt.I.get<ProvaController>();
  // final _dowloadStore = GetIt.I.get<UsuarioStore>();
  // final _provaStore = GetIt.I.get<ProvaStore>();
  // final _usuarioStore = GetIt.I.get<UsuarioStore>();

  // List<ProvaModel> provas = <ProvaModel>[];

  // await _usuarioStore.carregarUsuario();
  // if (_usuarioStore.token != null) {
  //   var retorno = await _provaController.obterProvas();
  //   if (retorno.length > 0) {
  //     for (var i = 0; i < retorno.length; i++) {
  //       //_provaStore.carregarProvaDetalhes(provaDetalhes);
  //       print("PROVA ${retorno[i]}}");
  //     }
  //   }
  // }

  //print('Acabou de aparecer uma mensagem:  ${message.messageId}');

  //debugger();
  //prefs.setString("testeMensagem", mensagem!);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeAppConfig();

  final ioc = new DependenciasIoC();
  ioc.registrarStores();
  ioc.registrarServices();
  ioc.registrarRepositories();
  ioc.registrarControllers();

  try {
    await Firebase.initializeApp();

    // FirebaseMessaging.instance.subscribeToTopic('1');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    print('Failed to initialize');
  }

  // Intl.defaultLocale = 'pt_BR';

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await SentryFlutter.init(
    (options) => options
      ..dsn = AppConfigReader.getSentryDsn()
      ..environment = AppConfigReader.getEnvironment()
      ..diagnosticLevel = SentryLevel.warning,
    appRunner: () => runApp(MyAppMobile()),
  );
}

class MyAppMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      locale: Locale('pt', 'BR'),
      home: SplashScreenView(),
      scaffoldMessengerKey: NotificationService.messengerKey,
    );
  }
}
