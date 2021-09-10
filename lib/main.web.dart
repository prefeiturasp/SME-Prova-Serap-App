import 'package:appserap/services/notification_service.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/utils/tema.util.dart';
import 'package:appserap/views/fluxo_inicial.view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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

Future<void> carregarUsuario(BuildContext context) async {
  final _usuarioStore = GetIt.I.get<UsuarioStore>();
  await _usuarioStore.carregarUsuario();

  Future.delayed(const Duration(seconds: 5), () => "5");

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => FluxoInicialView(),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeAppConfig();

  final ioc = new DependenciasIoC();
  ioc.registrarStores();
  ioc.registrarServices();
  ioc.registrarRepositories();
  ioc.registrarControllers();

  // Intl.defaultLocale = 'pt_BR';

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await SentryFlutter.init(
    (options) => options
      ..dsn = AppConfigReader.getSentryDsn()
      ..environment = AppConfigReader.getEnvironment(),
    appRunner: () => runApp(MyAppWeb()),
  );
}

class MyAppWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    carregarUsuario(context);

    return MaterialApp(
      // builder: (context, widget) => ResponsiveWrapper.builder(
      //   BouncingScrollWrapper.builder(context, widget!),
      //   maxWidth: 1200,
      //   minWidth: 450,
      //   defaultScale: true,
      //   breakpoints: [
      //     ResponsiveBreakpoint.resize(450, name: MOBILE),
      //     ResponsiveBreakpoint.autoScale(800, name: TABLET),
      //     ResponsiveBreakpoint.autoScale(1000, name: TABLET),
      //     ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
      //     ResponsiveBreakpoint.autoScale(2460, name: "4K"),
      //   ],
      //   background: Container(
      //     color: Color(0xFFF5F5F5),
      //   ),
      // ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TemaUtil.textoPrincipal(context),
      ),
      locale: Locale('pt', 'BR'),
      home: FluxoInicialView(),
      scaffoldMessengerKey: NotificationService.messengerKey,
    );
  }
}
