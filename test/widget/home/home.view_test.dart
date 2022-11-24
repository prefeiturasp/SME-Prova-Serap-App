import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
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
import 'home.view_test.mocks.dart';

@GenerateMocks([
  ApiService,
  PrincipalStore,
])
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

    await ServiceLocator.allReady();
  });

  tearDown(() {
    unregisterInjection<AppDatabase>(disposingFunction: (p0) => p0.close());
    unregisterInjection<RespostasDatabase>(disposingFunction: (p0) => p0.close());
  });

  mockPrincipalStore({bool temConexao = true}) {
    when(ServiceLocator.get<PrincipalStore>().usuario).thenReturn(ServiceLocator.get<UsuarioStore>());
    when(ServiceLocator.get<PrincipalStore>().temConexao).thenReturn(temConexao);
    when(ServiceLocator.get<PrincipalStore>().versao).thenReturn("");
  }

  group('Home - Abas provas finalizadas', () {
    testWidgets('Não deve exibir nenuma prova finalizada na listagem', (tester) async {
      await tester.runAsync(() async {
        await withClock(
          Clock.fixed(DateTime(2022, 8, 31)),
          (() async {
            mockPrincipalStore();

            var provaMock = MockProvaService();
            mockProvaNenhuma(provaMock);

            when(ServiceLocator.get<ApiService>().prova).thenReturn(provaMock);

            await tester.pumpWidget(MaterialApp(home: HomeView()));

            var botao = find.text('Provas anteriores');

            await tester.tap(botao);

            await tester.pumpAndSettle(Duration(seconds: 20));
          }),
        );

        expect(find.byKey(Key('carregando')), findsNothing);
        expect(find.byKey(Key('card-prova')), findsNWidgets(0));
        expect(find.byKey(Key('sem-itens-finalizados')), findsOneWidget);
      });
    });

    testWidgets('Deve exibir uma prova finalizada na listagem', (tester) async {
      await tester.runAsync(() async {
        await withClock(
          Clock.fixed(DateTime(2022, 8, 31)),
          (() async {
            mockPrincipalStore();

            var provaMock = MockProvaService();
            mockProvaFinalizada(provaMock);

            when(ServiceLocator.get<ApiService>().prova).thenReturn(provaMock);

            await tester.pumpWidget(MaterialApp(home: HomeView()));

            var botao = find.text('Provas anteriores');

            await tester.tap(botao);

            await tester.pumpAndSettle(Duration(seconds: 20));
          }),
        );

        expect(find.byKey(Key('carregando')), findsNothing);
        expect(find.byKey(Key('card-prova-finalizada')), findsNWidgets(1));
        expect(find.byKey(Key('sem-itens-finalizados')), findsNothing);
      });
    });
  });

  group('Home - Aba provas', () {
    testWidgets('Não deve exibir nenuma prova na listagem', (tester) async {
      await tester.runAsync(() async {
        await withClock(
          Clock.fixed(DateTime(2022, 8, 31)),
          (() async {
            mockPrincipalStore();

            var provaMock = MockProvaService();
            mockProvaNenhuma(provaMock);

            when(ServiceLocator.get<ApiService>().prova).thenReturn(provaMock);

            await tester.pumpWidget(MaterialApp(home: HomeView()));

            await tester.pumpAndSettle(Duration(seconds: 20));
          }),
        );

        expect(find.text('Prova atual'), findsOneWidget);
        expect(find.byKey(Key('carregando')), findsNothing);
        expect(find.byKey(Key('card-prova')), findsNWidgets(0));
        expect(find.byKey(Key('sem-itens')), findsOneWidget);
      });
    });

    testWidgets('Deve exibir uma prova na listagem', (tester) async {
      await tester.runAsync(() async {
        await withClock(
          Clock.fixed(DateTime(2022, 8, 31)),
          (() async {
            mockPrincipalStore();

            var provaMock = MockProvaService();
            await mockProvaSimples(provaMock);

            when(ServiceLocator.get<ApiService>().prova).thenReturn(provaMock);

            await tester.pumpWidget(MaterialApp(home: HomeView()));

            await tester.pumpAndSettle(Duration(seconds: 20));
          }),
        );

        expect(find.text('Prova atual'), findsOneWidget);
        expect(find.byKey(Key('carregando')), findsNothing);
        expect(find.byKey(Key('card-prova')), findsNWidgets(1));
        expect(find.byKey(Key('sem-itens')), findsNothing);
      });
    });

    testWidgets('Não deve exibir nenuma prova antecipada na listagem', (tester) async {
      await tester.runAsync(() async {
        await withClock(
          Clock.fixed(DateTime(2022, 8, 25)),
          (() async {
            mockPrincipalStore();

            var provaMock = MockProvaService();
            await mockProvaSimples(provaMock);

            when(ServiceLocator.get<ApiService>().prova).thenReturn(provaMock);

            await tester.pumpWidget(MaterialApp(home: HomeView()));

            await tester.pumpAndSettle(Duration(seconds: 20));
          }),
        );

        expect(find.text('Prova atual'), findsOneWidget);
        expect(find.byKey(Key('carregando')), findsNothing);
        expect(find.byKey(Key('card-prova')), findsNWidgets(0));
        expect(find.byKey(Key('sem-itens')), findsOneWidget);
      });
    });

    testWidgets('Não deve exibir nenuma prova expirada na listagem', (tester) async {
      await tester.runAsync(() async {
        await withClock(
          Clock.fixed(DateTime(2022, 9, 1)),
          (() async {
            mockPrincipalStore();

            var provaMock = MockProvaService();
            await mockProvaSimples(provaMock);

            when(ServiceLocator.get<ApiService>().prova).thenReturn(provaMock);

            await tester.pumpWidget(MaterialApp(home: HomeView()));

            await tester.pumpAndSettle(Duration(seconds: 20));
          }),
        );

        expect(find.text('Prova atual'), findsOneWidget);
        expect(find.byKey(Key('carregando')), findsNothing);
        expect(find.byKey(Key('card-prova')), findsNWidgets(0));
        expect(find.byKey(Key('sem-itens')), findsOneWidget);
      });
    });

    testWidgets('Não deve ser possivel iniciar a prova com tempo durante o final de semana', (tester) async {
      await tester.runAsync(() async {
        await withClock(
          Clock.fixed(DateTime(2022, 9, 1)),
          (() async {
            mockPrincipalStore();

            var provaMock = MockProvaService();
            await mockProvaSimples(provaMock);

            when(ServiceLocator.get<ApiService>().prova).thenReturn(provaMock);

            await tester.pumpWidget(MaterialApp(home: HomeView()));

            await tester.pumpAndSettle(Duration(seconds: 20));
          }),
        );

        expect(find.text('Prova atual'), findsOneWidget);
        expect(find.byKey(Key('carregando')), findsNothing);
        expect(find.byKey(Key('card-prova')), findsNWidgets(0));
        expect(find.byKey(Key('sem-itens')), findsOneWidget);
      });
    });
  });

  testWidgets('Deve exibir botão sem conexão', (tester) async {
    await tester.runAsync(() async {
      await withClock(
        Clock.fixed(DateTime(2022, 8, 26)),
        (() async {
          mockPrincipalStore(temConexao: false);

          await gravarProvaBanco(statusDownload: EnumDownloadStatus.NAO_INICIADO);

          var provaMock = MockProvaService();
          await mockProvaSimples(provaMock);

          when(ServiceLocator.get<ApiService>().prova).thenReturn(provaMock);

          await tester.pumpWidget(MaterialApp(home: HomeView()));

          await tester.pumpAndSettle(Duration(seconds: 20));
        }),
      );

      expect(find.text('Prova atual'), findsOneWidget);
      expect(find.byKey(Key('carregando')), findsNothing);
      expect(find.byKey(Key('card-prova')), findsNWidgets(1));
      expect(find.byKey(Key('sem-itens')), findsNothing);
      expect(find.byKey(Key('card-sem-conexao')), findsOneWidget);
    });
  });

  testWidgets('Deve exibir botão download pausado', (tester) async {
    await tester.runAsync(() async {
      await withClock(
        Clock.fixed(DateTime(2022, 8, 26)),
        (() async {
          mockPrincipalStore(temConexao: false);

          await gravarProvaBanco(statusDownload: EnumDownloadStatus.PAUSADO);

          var provaMock = MockProvaService();
          await mockProvaSimples(provaMock);

          when(ServiceLocator.get<ApiService>().prova).thenReturn(provaMock);

          await tester.pumpWidget(MaterialApp(home: HomeView()));

          await tester.pumpAndSettle(Duration(seconds: 20));
        }),
      );

      expect(find.text('Prova atual'), findsOneWidget);
      expect(find.byKey(Key('carregando')), findsNothing);
      expect(find.byKey(Key('card-prova')), findsNWidgets(1));
      expect(find.byKey(Key('sem-itens')), findsNothing);
      expect(find.byKey(Key('card-download-pausado')), findsOneWidget);
    });
  }, skip: true);

  testWidgets('Deve exibir botão pendente', (tester) async {
    await tester.runAsync(() async {
      await withClock(
        Clock.fixed(DateTime(2022, 8, 26)),
        (() async {
          mockPrincipalStore(temConexao: true);

          await gravarProvaBanco(statusDownload: EnumDownloadStatus.CONCLUIDO, statusProva: EnumProvaStatus.PENDENTE);

          var provaMock = MockProvaService();
          await mockProvaSimples(provaMock);

          when(ServiceLocator.get<ApiService>().prova).thenReturn(provaMock);

          await tester.pumpWidget(MaterialApp(home: HomeView()));

          await tester.pumpAndSettle(Duration(seconds: 20));
        }),
      );

      expect(find.text('Prova atual'), findsOneWidget);
      expect(find.byKey(Key('carregando')), findsNothing);
      expect(find.byKey(Key('card-prova')), findsNWidgets(1));
      expect(find.byKey(Key('sem-itens')), findsNothing);
      expect(find.byKey(Key('card-prova-pendente')), findsOneWidget);
    });
  });
}
