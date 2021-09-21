import 'package:appserap/dependencias.ioc.dart';
import 'package:appserap/ui/views/splashscreen/splash_screen.view.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/notificacao.util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:asuka/asuka.dart' as asuka;

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
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((rec) {
    print('(${rec.loggerName}) ${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

void registerFonts() {
  //Registrar fontes
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupAppConfig();

  registerFonts();

  setupLogging();

  final ioc = DependenciasIoC();
  ioc.registrar();

  initializeDateFormatting();
  Intl.defaultLocale = 'pt_BR';

  try {
    await Firebase.initializeApp();

    FirebaseMessaging.instance.subscribeToTopic('1');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    // ignore: avoid_print
    print('\n\nFalha ao inicializar\n\n');
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: asuka.builder,
      navigatorObservers: [asuka.asukaHeroController],
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
