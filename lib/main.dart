import 'dart:async';

import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart';
import 'package:appserap/utils/notificacao.util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'dependencias.ioc.dart';
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
  print('RECEBEU UMA MENSAGEM:');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeDateFormatting();
  Intl.defaultLocale = 'pt_BR';

  await initializeAppConfig();

  final ioc = new DependenciasIoC();
  ioc.registrarUtils();
  ioc.registrarServices();
  ioc.registrarStores();
  ioc.registrarRepositories();
  ioc.registrarControllers();

  try {
    await Firebase.initializeApp();

    FirebaseMessaging.instance.subscribeToTopic('1');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    print('\n\nFalha ao inicializar\n\n');
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
      ..debug = true
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
      scaffoldMessengerKey: NotificacaoUtil.messengerKey,
    );
  }
}
