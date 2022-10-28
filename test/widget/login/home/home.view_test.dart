import 'package:appserap/database/app.database.dart';
import 'package:appserap/database/respostas.database.dart';
import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes_caderno.response.dto.dart';
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

import '../../../fixtures/fixture_reader.dart';
import '../../../fixtures/user/http.fixture.dart';
import '../../../fixtures/user/locator.fixture.dart';
import 'home.view_test.mocks.dart';

@GenerateMocks([
  ApiService,
  PrincipalStore,
  ProvaService,
  QuestaoRespostaService,
])
void main() {
  setUpAll(() {
    initializeDateFormatting();
    Intl.defaultLocale = 'pt_BR';
    Logger.root.level = Level.FINER;

    Logger.root.onRecord.listen((rec) {
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

  mockProvaSimples(MockProvaService mock) {
    var json = fixture('prova_lista_simples.json');

    List<ProvaResponseDTO> response = [];

    for (var item in json) {
      response.add(ProvaResponseDTO.fromJson(item));
    }

    when(mock.getProvas()).thenAnswer((realInvocation) async => buildResponse(response));
  }

  mockProvaNenhuma(MockProvaService mock) {
    List<ProvaResponseDTO> response = [];

    when(mock.getProvas()).thenAnswer((realInvocation) async => buildResponse(response));
  }

  mockPrincipalStore() {
    when(ServiceLocator.get<PrincipalStore>().usuario).thenReturn(ServiceLocator.get<UsuarioStore>());
    when(ServiceLocator.get<PrincipalStore>().temConexao).thenReturn(true);
    when(ServiceLocator.get<PrincipalStore>().versao).thenReturn("");
  }

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
            mockProvaSimples(provaMock);

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
            mockProvaSimples(provaMock);

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
            mockProvaSimples(provaMock);

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
            mockProvaSimples(provaMock);

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
}
