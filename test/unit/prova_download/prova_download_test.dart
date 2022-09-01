import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes_caderno.response.dto.dart';
import 'package:appserap/dtos/questao_detalhes_legado.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/managers/download.manager.store.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/services/rest/download.service.dart';
import 'package:appserap/stores/usuario.store.dart';
import 'package:appserap/workers/jobs/baixar_prova.job.dart';
import 'package:chopper/chopper.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../fixtures/fixture_reader.dart';
import '../../fixtures/user/http.fixture.dart';
import '../../fixtures/user/locator.fixture.dart';
import '../../fixtures/user/user.fixture.dart';
import 'prova_download_test.mocks.dart';

import 'package:http/http.dart' as http;

@GenerateMocks([
  ApiService,
  ProvaService,
  QuestaoService,
  UsuarioStore,
  DownloadService,
  http.BaseResponse,
])
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group('Download -', () {
    mocksUsuarioStore() {
      when(GetIt.instance.get<UsuarioStore>().deficiencias).thenReturn(mobx.ObservableList());
    }

    mocksProvaService() {
      Future<Response<ProvaDetalhesCadernoResponseDTO>> getProvaDetalhesCadernoResponseDTO() async {
        return buildResponse(
          ProvaDetalhesCadernoResponseDTO.fromJson(fixture('prova_detalhes_caderno.json')),
        );
      }

      Future<Response<List<ProvaResponseDTO>>> getProvasResponseDTO() async {
        var json = fixture('prova_lista_simples.json');

        List<ProvaResponseDTO> response = [];

        for (var item in json) {
          response.add(ProvaResponseDTO.fromJson(item));
        }

        return buildResponse(response);
      }

      var provaServiceMock = MockProvaService();
      when(GetIt.instance.get<ApiService>().prova).thenAnswer((_) => provaServiceMock);

      when(provaServiceMock.getResumoProvaCaderno(idProva: anyNamed('idProva'), caderno: anyNamed('caderno')))
          .thenAnswer((_) => getProvaDetalhesCadernoResponseDTO());

      when(provaServiceMock.getProvas()).thenAnswer((_) => getProvasResponseDTO());
    }

    Future<Response<List<QuestaoDetalhesLegadoResponseDTO>>> getQuestaoCompletaLegado(
      List<int> ids, {
      bool erro = false,
    }) async {
      var idsString = ids.join('-');

      var json = fixture('questao_completa_$idsString${erro ? "_erro" : ""}.json');

      List<QuestaoDetalhesLegadoResponseDTO> response = [];

      for (var item in json) {
        response.add(QuestaoDetalhesLegadoResponseDTO.fromJson(item));
      }

      return buildResponse(response);
    }

    mocksDownloadService() {
      getInformarDownloadResponse() async {
        return buildResponse("instance");
      }

      var downloadServiceMock = MockDownloadService();

      when(GetIt.instance.get<ApiService>().download).thenAnswer((_) => downloadServiceMock);

      when(downloadServiceMock.informarDownloadConcluido(
        provaId: anyNamed("provaId"),
        tipoDispositivo: anyNamed("tipoDispositivo"),
        dispositivoId: anyNamed("dispositivoId"),
        modeloDispositivo: anyNamed("modeloDispositivo"),
        versao: anyNamed("versao"),
        dataHora: anyNamed("dataHora"),
      )).thenAnswer((realInvocation) => getInformarDownloadResponse());
    }

    setUpAll(() {
      registerInjection<AppDatabase>(AppDatabase.executor(NativeDatabase.memory()));
    });

    setUp(() async {
      registerInjection<ApiService>(MockApiService());
      registerInjection<ProvaService>(MockProvaService());
      registerInjection<QuestaoService>(MockQuestaoService());

      registerInjection<UsuarioStore>(MockUsuarioStore());

      registerInjection<http.BaseResponse>(MockBaseResponse());

      registerInjection<SharedPreferences>(await SharedPreferences.getInstance());

      mocksUsuarioStore();

      mocksProvaService();
      mocksDownloadService();
    });

    tearDown(() async {});

    test('Deve fazer o download da prova', () async {
      var questaoServiceMock = MockQuestaoService();

      when(GetIt.instance.get<ApiService>().questao).thenAnswer((_) => questaoServiceMock);

      when(questaoServiceMock.getQuestaoCompletaLegado(idsLegado: [21138, 21139]))
          .thenAnswer((_) => (getQuestaoCompletaLegado([21138, 21139])));

      when(questaoServiceMock.getQuestaoCompletaLegado(idsLegado: [21137, 21313]))
          .thenAnswer((_) => (getQuestaoCompletaLegado([21137, 21313])));

      when(questaoServiceMock.getQuestaoCompletaLegado(idsLegado: [21312]))
          .thenAnswer((_) => (getQuestaoCompletaLegado([21312])));

      int provaId = 179;
      String caderno = 'A';

      DownloadManagerStore downloadManagerStore = DownloadManagerStore(
        provaId: provaId,
        caderno: caderno,
      );

      await downloadManagerStore.iniciarDownload();

      var db = GetIt.instance.get<AppDatabase>();

      var questoes = await db.questaoDao.obterPorProvaId(provaId);

      expect(questoes.length, 5);
    });

    test('Deve baixar a prova pelo job de download antecipado', () async {
      var provaId = 179;

      when(GetIt.instance.get<UsuarioStore>().isRespondendoProva).thenReturn(false);

      GetIt.instance.get<SharedPreferences>().setString('token', UserFixture().autenticacaoResponse.token);

      await BaixarProvaJob().run();

      var db = GetIt.instance.get<AppDatabase>();

      var prova = await db.provaDao.obterPorProvaId(provaId);
      var questoes = await db.questaoDao.obterPorProvaId(provaId);

      expect(prova, isNotNull);
      expect(prova.id, provaId);
      expect(questoes.length, 5);
    });

    test('Deve retornar erro ao tentar baixar uma questao com imagem que tenha link da imagem invalido', () async {
      var questaoServiceMock = MockQuestaoService();

      when(GetIt.instance.get<ApiService>().questao).thenAnswer((_) => questaoServiceMock);

      when(questaoServiceMock.getQuestaoCompletaLegado(idsLegado: [21138, 21139]))
          .thenAnswer((_) => (getQuestaoCompletaLegado([21138, 21139])));

      when(questaoServiceMock.getQuestaoCompletaLegado(idsLegado: [21137, 21313]))
          .thenAnswer((_) => (getQuestaoCompletaLegado([21137, 21313])));

      when(questaoServiceMock.getQuestaoCompletaLegado(idsLegado: [21312]))
          .thenAnswer((_) => (getQuestaoCompletaLegado([21312], erro: true)));

      int provaId = 179;
      String caderno = 'A';

      var provas = await GetIt.instance.get<ApiService>().prova.getProvas();

      GetIt.instance.get<AppDatabase>().provaDao.inserirOuAtualizar(provas.body!.first.toProvaModel());

      DownloadManagerStore downloadManagerStore = DownloadManagerStore(
        provaId: provaId,
        caderno: caderno,
      );

      downloadManagerStore.onError(
        (mensagem) => expect(mensagem, 'Não foi possível baixar todo o conteúdo da prova id: 179'),
      );

      await downloadManagerStore.iniciarDownload();

      var db = GetIt.instance.get<AppDatabase>();

      var prova = await db.provaDao.obterPorProvaId(provaId);
      expect(prova.downloadStatus, EnumDownloadStatus.ERRO);

      var questoes = await db.questaoDao.obterPorProvaId(provaId);

      expect(questoes.length, 4);
    });
  });
}
