import 'package:appserap/database/app.database.dart';
import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/dtos/prova_detalhes_caderno.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/main.ioc.dart';
import 'package:appserap/models/prova_aluno.model.dart';
import 'package:appserap/services/api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fixture_reader.dart';
import 'mocks.provas.mocks.dart';
import 'user/http.fixture.dart';

@GenerateMocks([
  ProvaService,
  QuestaoRespostaService,
])
class MocsProva {}

mockProvaSimples(
  MockProvaService mock, {
  bool forcarBaixada = false,
  EnumDownloadStatus status = EnumDownloadStatus.CONCLUIDO,
}) async {
  var json = fixture('prova_lista_simples.json');

  List<ProvaResponseDTO> response = [];

  for (var item in json) {
    var provaDTO = ProvaResponseDTO.fromJson(item);

    response.add(provaDTO);

    if (forcarBaixada) {
      var provaModel = provaDTO.toProvaModel();
      provaModel.downloadStatus = status;
      provaModel.idDownload = "1";

      await sl.get<AppDatabase>().provaDao.inserirOuAtualizar(provaModel);
    }
  }

  when(mock.getProvas()).thenAnswer((realInvocation) async => buildResponse(response));
}

gravarProvaBanco(
    {EnumDownloadStatus statusDownload = EnumDownloadStatus.CONCLUIDO,
    EnumProvaStatus statusProva = EnumProvaStatus.NAO_INICIADA}) async {
  var json = fixture('prova_lista_simples.json');

  List<ProvaResponseDTO> response = [];

  for (var item in json) {
    var provaDTO = ProvaResponseDTO.fromJson(item);

    response.add(provaDTO);

    var provaModel = provaDTO.toProvaModel();
    provaModel.downloadStatus = statusDownload;
    provaModel.status = statusProva;
    provaModel.idDownload = "1";

    await sl.get<AppDatabase>().provaDao.inserirOuAtualizar(provaModel);

    var provaAluno = ProvaAluno(
      codigoEOL: '5720828',
      provaId: provaModel.id,
    );

    await sl.get<AppDatabase>().provaAlunoDao.inserirOuAtualizar(provaAluno);
  }
}

mockProvaComTempo(MockProvaService mock,
    {bool forcarBaixada = false, EnumDownloadStatus status = EnumDownloadStatus.CONCLUIDO}) async {
  var json = fixture('prova_lista_tempo.json');

  List<ProvaResponseDTO> response = [];

  for (var item in json) {
    var provaDTO = ProvaResponseDTO.fromJson(item);

    response.add(provaDTO);

    if (forcarBaixada) {
      var provaModel = provaDTO.toProvaModel();
      provaModel.downloadStatus = status;
      provaModel.idDownload = "1";

      await sl.get<AppDatabase>().provaDao.inserirOuAtualizar(provaModel);
    }
  }

  when(mock.getProvas()).thenAnswer((realInvocation) async => buildResponse(response));
}

mockProvaDetalhesCaderno(MockProvaService mock) {
  var response = buildResponse(
    ProvaDetalhesCadernoResponseDTO.fromJson(fixture('prova_detalhes_caderno.json')),
  );

  when(mock.getResumoProvaCaderno(
    idProva: anyNamed('idProva'),
    caderno: anyNamed('caderno'),
  )).thenAnswer(
    (_) async => response,
  );
}

mockProvaNenhuma(MockProvaService mock) {
  List<ProvaResponseDTO> response = [];

  when(mock.getProvas()).thenAnswer((realInvocation) async => buildResponse(response));
}

mockProvaFinalizada(MockProvaService mock) {
  var json = fixture('prova_lista_finalizada.json');

  List<ProvaResponseDTO> response = [];

  for (var item in json) {
    response.add(ProvaResponseDTO.fromJson(item));
  }

  when(mock.getProvas()).thenAnswer((realInvocation) async => buildResponse(response));
}
