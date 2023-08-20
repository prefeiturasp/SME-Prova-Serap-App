import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/home.store.dart';
import 'package:appserap/stores/job.store.dart';
import 'package:appserap/stores/principal.store.dart';
import 'package:appserap/stores/tema.store.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/ui/views/home/home.view.dart';
import 'package:clock/clock.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

import '../../fixtures/fixture_reader.dart';
import '../../fixtures/mocks.provas.dart';
import '../../fixtures/mocks.provas.mocks.dart';
import '../../fixtures/user/locator.fixture.dart';
import 'home.view_turno_test.mocks.dart';

@GenerateMocks(
  [
    ApiService,
    PrincipalStore,
    AppDatabase,
  ],
)
void main() {
  setUpAll(() {
    initializeDateFormatting();
    Intl.defaultLocale = 'pt_BR';
    Logger.root.level = Level.FINER;

    Logger.root.onRecord.listen((rec) {
      // ignore: avoid_print
      print('${rec.level.name}: ${rec.time}: (${rec.loggerName}) ${rec.message}');
    });

    PackageInfo.setMockInitialValues(
      appName: "abc",
      packageName: "com.example.example",
      version: "1.0",
      buildNumber: "2",
      buildSignature: "buildSignature",
    );
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues(Map<String, Object>.from(fixture('usuario_simples_tarde.json')));

    registerInjection<AppDatabase>(AppDatabase.executor(NativeDatabase.memory()));
    registerInjection<RespostasDatabase>(RespostasDatabase.executor(NativeDatabase.memory()));

    registerInjectionAsync<SharedPreferences>(() => SharedPreferences.getInstance());

    Future<UsuarioStore> teste() async {
      UsuarioStore u = UsuarioStore();
      u.carregarUsuario();
      return u;
    }

    registerInjection<UsuarioStore>(await teste());

    registerInjection<PrincipalStore>(MockPrincipalStore());
    registerInjection<ApiService>(MockApiService());

    registerInjection<TemaStore>(TemaStore());
    registerInjection<JobStore>(JobStore());

    registerInjection<HomeStore>(HomeStore());

    await sl.allReady();
  });

  tearDown(() {
    unregisterInjection<AppDatabase>(disposingFunction: (p0) => p0.close());
    unregisterInjection<RespostasDatabase>(disposingFunction: (p0) => p0.close());
  });

  mockPrincipalStore() {
    when(sl.get<PrincipalStore>().usuario).thenReturn(sl.get<UsuarioStore>());
    when(sl.get<PrincipalStore>().temConexao).thenReturn(true);
    when(sl.get<PrincipalStore>().versao).thenReturn("");
  }

  group('Home - Turnos', () {
    testWidgets('Deve exibir mensagem fora do horario da prova - Usuário turno tarde no horário da manhã',
        (tester) async {
      await tester.runAsync(() async {
        await withClock(
          Clock.fixed(DateTime(2022, 8, 31, 9, 0)),
          (() async {
            mockPrincipalStore();

            var provaMock = MockProvaService();
            await mockProvaComTempo(provaMock, forcarBaixada: true);
            mockProvaDetalhesCaderno(provaMock);

            when(sl<ProvaService>()).thenReturn(provaMock);

            await tester.pumpWidget(MaterialApp(home: HomeView()));

            await tester.pumpAndSettle(Duration(seconds: 20));
          }),
        );

        expect(find.text('Prova atual'), findsOneWidget);
        expect(find.byKey(Key('carregando')), findsNothing);
        expect(find.byKey(Key('card-prova')), findsNWidgets(1));
        expect(find.byKey(Key('sem-itens')), findsNothing);
        expect(find.byKey(Key('prova-indiponivel-turno')), findsOneWidget);
      });
    });

    testWidgets('Deve exibir prova para iniciar - Usuário turno tarde no horário da tarde', (tester) async {
      await tester.runAsync(() async {
        await withClock(
          Clock.fixed(DateTime(2022, 8, 31, 15, 0)),
          (() async {
            mockPrincipalStore();

            var provaMock = MockProvaService();
            await mockProvaComTempo(provaMock, forcarBaixada: true);
            mockProvaDetalhesCaderno(provaMock);

            when(sl<ProvaService>()).thenReturn(provaMock);

            await tester.pumpWidget(MaterialApp(home: HomeView()));

            await tester.pumpAndSettle(Duration(seconds: 20));
          }),
        );

        expect(find.text('Prova atual'), findsOneWidget);
        expect(find.byKey(Key('carregando')), findsNothing);
        expect(find.byKey(Key('card-prova')), findsNWidgets(1));
        expect(find.byKey(Key('sem-itens')), findsNothing);
        expect(find.byKey(Key('prova-indiponivel-turno')), findsNothing);
        expect(find.byKey(Key('botao-prova-iniciar')), findsOneWidget);
      });
    });

    testWidgets('Deve exibir mensagem fora do horario da prova - Usuário turno tarde no horário da noite',
        (tester) async {
      await tester.runAsync(() async {
        await withClock(
          Clock.fixed(DateTime(2022, 8, 31, 21, 0)),
          (() async {
            mockPrincipalStore();

            var provaMock = MockProvaService();
            await mockProvaComTempo(provaMock, forcarBaixada: true);
            mockProvaDetalhesCaderno(provaMock);

            when(sl<ProvaService>()).thenReturn(provaMock);

            await tester.pumpWidget(MaterialApp(home: HomeView()));

            await tester.pumpAndSettle(Duration(seconds: 20));
          }),
        );

        expect(find.text('Prova atual'), findsOneWidget);
        expect(find.byKey(Key('carregando')), findsNothing);
        expect(find.byKey(Key('card-prova')), findsNWidgets(1));
        expect(find.byKey(Key('sem-itens')), findsNothing);
        expect(find.byKey(Key('prova-indiponivel-turno')), findsOneWidget);
      });
    });
  });
}
