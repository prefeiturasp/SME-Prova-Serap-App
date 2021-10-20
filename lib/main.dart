// ignore_for_file: avoid_print

import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:asuka/asuka.dart' as asuka;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

import 'package:appserap/main.ioc.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/notificacao.util.dart';
import 'package:appserap/workers/dispacher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDateFormating();
  setupLogging();
  registerFonts();

  await setupAppConfig();

  await DependenciasIoC().setup();

  await Worker().setup();

  try {
    await Firebase.initializeApp();

    //await FirebaseMessaging.instance.subscribeToTopic('1');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    print('\n\nFalha ao inicializar Firebase\n\n');
  }

  // await SentryFlutter.init(
  //   (options) => options
  //     ..dsn = AppConfigReader.getSentryDsn()
  //     ..environment = AppConfigReader.getEnvironment()
  //     ..debug = true
  //     ..diagnosticLevel = SentryLevel.warning,
  //   appRunner: () => runApp(MyApp()),
  // );
  runApp(MyApp());
}

Future setupAppConfig() async {
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

void setupLogging() {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: (${rec.loggerName}) ${rec.message}');
  });
}

void registerFonts() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}

setupDateFormating() {
  initializeDateFormatting();
  Intl.defaultLocale = 'pt_BR';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: asuka.builder,
      navigatorObservers: [asuka.asukaHeroController],
      debugShowCheckedModeBanner: kDebugMode,
      theme: ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(backgroundColor: TemaUtil.appBar),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(TemaUtil.laranja01),
            ),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      locale: Locale('pt', 'BR'),
      home: SplashScreenView(),
      scaffoldMessengerKey: NotificacaoUtil.messengerKey,
    );
  }
}
