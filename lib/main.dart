// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/notificacao.util.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/workers/dispacher.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';

import 'utils/firebase.util.dart';

var logger = Logger('Main');

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await configure();

    await Worker().setup();

    await setupFirebase();

    runApp(MyApp());
  }, (error, stack) {
    recordError(error, stack);
  });
}

registerPluginsForIsolate() {
  if (Platform.isAndroid) {
    SharedPreferencesAndroid.registerWith();
    PathProviderAndroid.registerWith();
  }
  if (Platform.isIOS) {
    SharedPreferencesIOS.registerWith();
    PathProviderIOS.registerWith();
  }

  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);
}

configure() async {
  print('Configurando App');
  setupDateFormating();
  setupLogging();
  registerFonts();

  await setupAppConfig();

  await DependenciasIoC().setup();

  TelaAdaptativaUtil().setup();
}

Future setupAppConfig() async {
  try {
    await AppConfigReader.initialize();
  } catch (e, stack) {
    print("Erro ao ler arquivo de configurações.");
    print("Verifique se seu projeto possui o arquivo config/app_config.json");
    print('$e');
    await recordError(e, stack);
  }
}

void setupLogging() {
  if (kDebugMode) {
    Logger.root.level = Level.FINE;
  } else {
    Logger.root.level = AppConfigReader.logLevel();
  }

  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: (${rec.loggerName}) ${rec.message}');
  });
}

void registerFonts() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['fonts'], license);
  });
}

setupDateFormating() {
  initializeDateFormatting();
  Intl.defaultLocale = 'pt_BR';
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(
        960,
        600,
      ),
      builder: (context, child) {
        final GoRouter goRouter = ServiceLocator.get<AppRouter>().router;

        return MaterialApp.router(
          routeInformationParser: goRouter.routeInformationParser,
          routerDelegate: goRouter.routerDelegate,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            appBarTheme: AppBarTheme(backgroundColor: TemaUtil.appBar),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(TemaUtil.laranja01),
              ),
            ),
          ),
          locale: Locale('pt', 'BR'),
          scaffoldMessengerKey: NotificacaoUtil.messengerKey,
          onGenerateTitle: (context) => "SERAp Estudantes",
        );
      },
    );
  }
}
