// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:appserap/main.ioc.dart';
import 'package:appserap/main.route.dart';
import 'package:appserap/utils/app_config.util.dart';
import 'package:appserap/utils/notificacao.util.dart';
import 'package:appserap/utils/route_observer.dart';
import 'package:appserap/utils/tela_adaptativa.util.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/workers/dispacher.dart';
import 'package:appserap/utils/firebase.util.dart';
import 'package:drift_local_storage_inspector/drift_local_storage_inspector.dart';
import 'package:file_local_storage_inspector/file_local_storage_inspector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:storage_inspector/storage_inspector.dart';

import 'database/app.database.dart';
import 'database/respostas.database.dart';
import 'main.isolate.dart';

var logger = Logger('Main');

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await configure(false);

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

  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);
}

configure(bool isBackground) async {
  print('Configurando App');
  await setupAppConfig();

  setupDateFormating();
  setupLogging();
  registerFonts();

  configureDependencies();

  if (isBackground) {
    await AppIsolates().setup();
  }

  if (!isBackground && kDebugMode) {
    setupDatabaseInspector();
  }

  TelaAdaptativaUtil().setup();
}

setupDatabaseInspector() async {
  logger.info("Configurando inspetor");

  final driver = StorageServerDriver(
    bundleId: 'br.gov.sp.prefeitura.sme.appserap',
  );

  final driftDb = sl.get<AppDatabase>();
  final sqlServer = DriftSQLDatabaseServer(
    id: "1",
    name: "App",
    database: driftDb,
  );
  driver.addSQLServer(sqlServer);

  final respostasDb = sl.get<RespostasDatabase>();
  final sqlServerRespostas = DriftSQLDatabaseServer(
    id: "1",
    name: "Respostas",
    database: respostasDb,
  );
  driver.addSQLServer(sqlServerRespostas);

  final fileServer = DefaultFileServer('.', 'App Documents');
  driver.addFileServer(fileServer);

  await driver.start(paused: false);
}

Future setupAppConfig() async {
  try {
    await AppConfigReader.initialize();
  } catch (e, stack) {
    print("Erro ao ler arquivo de configurações.");
    print("Verifique o arquivo .env");
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

  var logDisable = ['fwfh.HtmlWidget'];

  Logger.root.onRecord.listen((rec) {
    if (!logDisable.contains(rec.loggerName)) {
      print('${rec.level.name}: ${rec.time}: (${rec.loggerName}) ${rec.message}');
    }
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
  final _appRouter = sl<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(
        960,
        600,
      ),
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: _appRouter.config(
            navigatorObservers: () => [RouterObserver()],
          ),
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
