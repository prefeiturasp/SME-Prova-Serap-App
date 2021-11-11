import 'package:appserap/database/app.database.dart';
import 'package:chopper/src/response.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'package:appserap/dtos/prova.response.dto.dart';
import 'package:appserap/enums/download_status.enum.dart';
import 'package:appserap/enums/prova_status.enum.dart';
import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:appserap/models/prova.model.dart';
import 'package:appserap/services/api.dart';
import 'package:appserap/stores/prova.store.dart';
import 'package:appserap/stores/prova_resposta.store.dart';
import 'package:appserap/utils/provas.util.dart';

part 'home.store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store, Loggable, Disposable {
  @observable
  ObservableMap<int, ProvaStore> provas = ObservableMap<int, ProvaStore>();

  @observable
  bool carregando = false;

  @action
  carregarProvas() async {
    carregando = true;

    Map<int, ProvaStore> provasStore = {};

    AppDatabase db = GetIt.I.get();

    List<ProvaDb> provasDb = await db.obterProvas();
    if (provasDb.isNotEmpty) {
      List<Prova> provas = provasDb.map((e) => Prova.fromProvaDb(e)).cast<Prova>().toList();

      for (var prova in provas) {
        provasStore[prova.id] = ProvaStore(
          id: prova.id,
          prova: prova,
          respostas: ProvaRespostaStore(idProva: prova.id),
        );
      }
    }

    ConnectivityStatus resultado = await (Connectivity().checkConnectivity());

    // Atualizar lista de provas do cache
    if (resultado != ConnectivityStatus.none) {
      try {
        Response<List<ProvaResponseDTO>> response = await GetIt.I.get<ApiService>().prova.getProvas();

        if (response.isSuccessful) {
          var provasResponse = response.body!;

          for (var provaResponse in provasResponse) {
            var prova = Prova(
              id: provaResponse.id,
              descricao: provaResponse.descricao,
              itensQuantidade: provaResponse.itensQuantidade,
              dataInicio: provaResponse.dataInicio,
              dataFim: provaResponse.dataFim,
              status: provaResponse.status,
              tempoExecucao: provaResponse.tempoExecucao,
              tempoExtra: provaResponse.tempoExtra,
              tempoAlerta: provaResponse.tempoAlerta,
              dataInicioProvaAluno: provaResponse.dataInicioProvaAluno,
              questoes: [],
              senha: provaResponse.senha,
            );

            var provaStore = ProvaStore(
              id: provaResponse.id,
              prova: prova,
              respostas: ProvaRespostaStore(idProva: provaResponse.id),
            );

            // caso nao tenha o id, define como nova prova
            if (!provasStore.keys.contains(provaStore.id)) {
              provaStore.downloadStatus = EnumDownloadStatus.NAO_INICIADO;
              provaStore.prova.downloadStatus = EnumDownloadStatus.NAO_INICIADO;
            } else {
              provaStore.downloadStatus = EnumDownloadStatus.CONCLUIDO;
              provaStore.prova.downloadStatus = EnumDownloadStatus.CONCLUIDO;

              if (provasStore[prova.id]!.status != EnumProvaStatus.PENDENTE) {
                provaStore.status = prova.status;
              } else {
                provaStore.status = provasStore[prova.id]!.status;
                prova.status = provasStore[prova.id]!.status;
              }
            }

            provasStore[provaStore.id] = provaStore;
          }

          var idsRemote = provasResponse.map((e) => e.id).toList();

          for (var provaDb in provasDb) {
            if (!idsRemote.contains(provaDb.id)) {
              await removerProvaLocal(provasStore[provaDb.id]!);
            }
          }
          provasStore.removeWhere((idProva, prova) => !idsRemote.contains(idProva));
        }
      } catch (e, stacktrace) {
        severe(e);
        severe(stacktrace);
      }
    }

    if (provasStore.isNotEmpty) {
      var mapEntries = provasStore.entries.toList()
        ..sort((a, b) => a.value.prova.dataInicio.compareTo(b.value.prova.dataInicio));

      provasStore
        ..clear()
        ..addEntries(mapEntries);

      for (var provaStore in provasStore.values) {
        await carregaProva(provaStore.id, provaStore);
        provaStore.configure();
      }
    }
    provas = ObservableMap.of(provasStore);

    carregando = false;
  }

  Future<void> carregaProva(int idProva, ProvaStore provaStore) async {
    Prova? prova = await Prova.carregaProvaCache(idProva);

    if (prova != null) {
      // atualizar prova com os valores remotos
      prova.status = provaStore.prova.status;
      prova.dataInicioProvaAluno = provaStore.prova.dataInicioProvaAluno;

      provaStore.prova = prova;
      provaStore.downloadStatus = prova.downloadStatus;
      provaStore.progressoDownload = prova.downloadProgresso;
    }

    await Prova.salvaProvaCache(provaStore.prova);

    if (provaStore.downloadStatus != EnumDownloadStatus.CONCLUIDO) {
      provaStore.iniciarDownload();
    }
  }

  @override
  onDispose() {
    limpar();
  }

  @action
  limpar() {
    provas = <int, ProvaStore>{}.asObservable();
  }
}
